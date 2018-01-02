"""This module is built to use the bro binary to read
pcap's and push them through rock to generate bro logs
with the local.bro enabled.

This module was designed to be run on the command line
and has a help menu to further explain what each argument
can be passed.

Arguments -d and -f are required but conflict if used
together.
"""
from __future__ import absolute_import, division, print_function


from functools import partial
from uuid import uuid4
from tempfile import mkdtemp

import subprocess
import argparse
import multiprocessing
import os
import sys
import shlex
import logging
import traceback
import time


def set_logging():
    """Common function used for logging. log file is saved in the script directory with
    the .stderr extension.
    """
    # Set logging level. Log to directory script was run from as __file__.stderr
    logging_level = logging.INFO
    logging.basicConfig(
        filename='{}/{}.stderr'.format(
            os.path.dirname(os.path.abspath(__file__)),
            os.path.splitext(os.path.basename(os.path.abspath(__file__)))[0]
        ),
        level=logging_level,
        format='%(asctime)s %(levelname)-8s: %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        stream=sys.stdout
    )


def get_pcap_files_recursive(top_dir):
    """Walk from the top level provided and locate each pcap file.
    After which we will return a list of pcaps to iterate through
    and will be passed to the bro binary.
    """
    pcap_files = []
    try:
        for root, dirs, files in os.walk(top_dir):
            for file_name in files:
                pcap_files.append('{}{}'.format(root, file_name))
        if not pcap_files:
            raise ValueError
        return pcap_files
    except ValueError:
        print('No files exist in {}'.format(top_dir))
        exit(1)



def get_pcap_files(dir_path):
    """Return a list of pcap files in a single directory to iterate
     through and pass to the bro binary.
     """
    try:
        pcap_files = [f for f in os.listdir(dir_path) if os.path.isfile(os.path.join(dir_path, f))]
        if not pcap_files:
            raise ValueError
        return pcap_files

    except ValueError:
        print('No files exist in {}'.format(dir))
        exit(1)


def get_pcap_file(file_name):
    """Retrive a single pcap file to push through the bro binary"""
    try:
        file_path = os.path.abspath(file_name)
        result = os.path.isfile(file_path)
        if not result:
            raise ValueError

        pcap_files = [file_path]
        return pcap_files

    except ValueError:
        print('{} Is not a File'.format(file_path))
        exit(1)


def get_args():
    """Standard funtion to define and retrive all arguments that can be passed.
    Either -d or -f is required for this script but will exit if both are provided.
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--directory', help='directory containing pcap')
    parser.add_argument('-r', '--recursive', action="store_true",
                        help='find pcap recursively starting from directory provided',
                        default=False)
    parser.add_argument('-v', '--verbose', action="store_true", help='Enable Verbose output',
                        default=False)
    parser.add_argument('-f', '--file', help='process a single Pcap file')
    parser.add_argument('-w', '--workers', type=int,
                        help='Number of Parallel workers to process pcap', default=1)
    parser.add_argument('-s', '--source', help='Used to supply the ROCK::sensor_id variable',
                        default=uuid4())
    parser.add_argument('-b', '--bro_path', help='Path to Bro executable',
                        default='/usr/bin/bro')
    args = parser.parse_args()

    # Check for Conflicting options
    if args.directory and args.file:
        parser.error('Can only use one of the following options [-d,-f]')

    # Check for at least one valid option
    if not args.directory and not args.file:
        parser.error('Must supply either one of the following option [-d,-f]')
    return args


def get_bro_executable(bro_path):
    """Attempt to locate the bro binary, if it can not be found
    the user will be promoted for suggested solutions.
    """
    try:
        # see if it is in the default rock location
        if bro_path:
            if os.path.isfile(bro_path) and os.access(bro_path, os.X_OK):
                pass
            else:
                print('{} is either not a file or executable'.format(bro_path),
                      file=sys.stderr)
                exit(1)
        else:
            bro_path = subprocess.check_output(shlex.split('which bro'))
            if bro_path:
                pass
            else:
                print('Could not locate bro executable, '
                      'perhaps add it to your path or use the --bro_path option',
                      file=sys.stderr)
                exit(1)
        return bro_path
    except subprocess.CalledProcessError as err:

        # Attempt to use the find command to locate bro executible
        print('Could not locate bro executable, perhaps add it to your path '
              'or use the --bro_path option\n{}'.format(err), file=sys.stderr)
        exit(1)


def run_bro_replay(pcap, args):
    """Function that takes a supplied list of pcap files
    and location of the bro binary and executes the bro
    replay.
    """
    try:
        bro_path = args[0]
        source = args[1]
        # move into temp directory to process
        temp_dir = mkdtemp()
        os.chdir(temp_dir)
        # Bro command to replay pcap
        command = r'{} -C -r {} local "ROCK::sensor_id={}"'.format(bro_path, pcap, source)
        # Run the command
        subprocess.call(shlex.split(command), stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    except Exception:
        print('Failed to process {}'.format(pcap))
        print('See {}.stderr for more details'.format(os.path.splitext(__file__)[0]))
        logging.error('Failed to process %s\n%s', pcap, traceback.format_exc())


def run():
    """Main function used for the logic of the entire module.

    Retrieve args, locate pcap files, then locate bro executable.

    Then create a pool of workers which defaults to 1 should the
    user want to use multiple threads to parse their pcap. This only
    works should they provide multiple pcaps as each worker will
    run bro against a pcap, and then take another task once completed.

    If in verbose mode it will display every 10 seconds how many
    jobs are still in the que.
    """
    # get arguments
    args = get_args()
    set_logging()
    # make sure we are working in the directory of the python executable
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    if args.directory:
        if args.recursive:
            # get a list of all possible pcap files in directory and sub directories
            pcap_list = get_pcap_files_recursive(args.directory)
        else:
            # get a list of all possible pcap files in directory
            pcap_list = get_pcap_files(args.directory)
    else:
        # get absolute path to single pcap file
        pcap_list = get_pcap_file(args.file)

    # locate the bro executable
    bro_path = get_bro_executable(args.bro_path)

    # the number of threads to enable
    workers = args.workers

    # assigning the workers to a pool
    pool = multiprocessing.Pool(processes=workers)

    # map the fuction and send the data needed for the function
    result = pool.map_async(partial(run_bro_replay, args=[bro_path, args.source]), pcap_list)
    if args.verbose:
        while not result.ready():
            print('Pcap Left to Process: {}'.format(result._number_left))
            time.sleep(10)
    pool.close()
    pool.join()
    print('Pcap processed. ROCK::sensor_id={}'.format(args.source))


if __name__ == '__main__':
    run()
