from __future__ import print_function
from builtins import range

from libc.stdlib cimport rand, malloc, free, srand
from libc.time cimport time
from cpython.version cimport PY_MAJOR_VERSION


cdef char ZERO_CHAR = 48
srand(time(NULL))


def verify(string):
    """
    Check if the provided string of digits satisfies the Luhn checksum.

    :param string: Numeric string
    :type string: str
    :return: True if the string passes Luhn check
    :rtype: bool
    """
    return (_checksum(string) == 0)


def get_check_digit(string):
    """
    Generate the Luhn check digit to append to the provided string.

    :param string: Numeric string
    :type string: str
    :return: Check digit calculated from input
    :rtype: int
    """
    if PY_MAJOR_VERSION > 2:
        string = bytes(string + '0', 'ascii')
    else:
        string += '0'

    return cget_check_digit(string, len(string))


cdef int cget_check_digit(char* cstring, Py_ssize_t stringsize):
    return (10 - cchecksum(cstring, stringsize)) % 10


def append_check_digit(string):
    """
    Append Luhn check digit to the end of the provided string. Returns a new
    string with the appended digit.

    :param string: Numeric string
    :type string: str
    :return: Input string with calculated check digit appended
    :rtype: str
    """
    return '%s%d' % (string, get_check_digit(string))


def generate_valid_luhn_str(ndigits):
    """
    Generate a random numeric string of length `ndigits` with a valid luhn check digit

    :param ndigits: Length of string to generate
    :type ndigits: int
    :return: Numeric string of length `ndigits` with a valid Luhn check digit
    :rtype: str
    """
    return append_check_digit(_get_rand_numeric_str(ndigits - 1))


def _checksum(string):
    if PY_MAJOR_VERSION > 2:
        string = bytes(string, 'ascii')

    res = cchecksum(string, len(string))
    if res == -1:
        raise ValueError('Input must be numeric')
    return res


cdef int cchecksum(char* string, Py_ssize_t stringsize):
    cdef bint is_odd = 1
    cdef int odd_sum = 0
    cdef int even_sum = 0
    cdef int cur_digit
    cdef int i = stringsize - 1

    while i > -1:
        cur_digit = string[i] - ZERO_CHAR
        # print(cur_digit)
        if cur_digit < 0 or cur_digit > 9:
            return -1

        if is_odd:
            odd_sum += cur_digit
        else:
            cur_digit *= 2
            if cur_digit > 9:
                cur_digit -= 9
            even_sum += cur_digit

        is_odd = not is_odd
        # print('odd = %d; even = %d' % (odd_sum, even_sum))
        i -= 1

    return (odd_sum + even_sum) % 10


cdef char* cget_rand_numeric_str(int ndigits):
    cdef char* out = <char*> malloc((ndigits + 1) * sizeof(char))
    cdef int i = 0

    while i < ndigits:
        out[i] = rand() % 10 + ZERO_CHAR
        i += 1
    out[ndigits] = 0

    return out


def _get_rand_numeric_str(ndigits):
    cdef char* c_str

    try:
        c_str = cget_rand_numeric_str(ndigits)
        if PY_MAJOR_VERSION < 3:
            return c_str[:ndigits]
        else:
            return c_str[:ndigits].decode()
    finally:
        free(c_str)


def _cli_generate():
    import argparse

    parser = argparse.ArgumentParser(
        description='Generate serial numbers with valid Luhn check digit')
    parser.add_argument('-d', '--ndigits', required=True, type=int,
                        help='Number of digits in each generated serial number')
    parser.add_argument('-n', '--nserials', required=True, type=int,
                        help='Number of serial numbers to generate')

    args = parser.parse_args()
    for i in range(args.nserials):
        print(generate_valid_luhn_str(args.ndigits))
