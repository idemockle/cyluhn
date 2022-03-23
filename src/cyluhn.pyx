import random
import string

from libc.stdlib cimport div, div_t, rand, malloc, free


def verify(string):
    """
    Check if the provided string of digits satisfies the Luhn checksum.
    """
    return (_checksum(string) == 0)


def generate_digit(string):
    """
    Generate the Luhn check digit to append to the provided string.
    """
    return (10 - _checksum(string + '0')) % 10


def append(string):
    """
    Append Luhn check digit to the end of the provided string. Returns a new
    string with the appended digit.
    """
    return '%s%d' % (string, generate_digit(string))


def generate_valid_luhn_str(ndigits):
    """
    Generate a random numeric string of length `ndigits` with a valid luhn check digit
    :param ndigits:
    :return:
    """
    # return append(''.join(random.choices(string.digits, k=ndigits - 1)))
    return append(get_rand_numeric_str(ndigits - 1))


def _checksum(string):
    """
    Compute the Luhn checksum for the provided string of digits. Note this
    assumes the check digit is in place.
    """
    res = cchecksum(bytes(string, 'ascii'), len(string))
    if res == -1:
        raise ValueError('Input must be numeric')
    return res


cdef int cchecksum(char* string, Py_ssize_t stringsize):
    cdef div_t even_div
    cdef bint is_odd = 1
    cdef int odd_sum = 0
    cdef int even_sum = 0
    cdef char zero = 48 # '0' char
    cdef int cur_digit

    for i in range(stringsize - 1, -1, -1):
        cur_digit = string[i] - zero
        # print(cur_digit)
        if cur_digit < 0 or cur_digit > 9:
            return -1

        if is_odd:
            odd_sum += cur_digit
        else:
            even_div = div(2 * cur_digit, 10)
            even_sum += even_div.quot + even_div.rem

        is_odd = not is_odd
        # print('odd = %d; even = %d' % (odd_sum, even_sum))

    return (odd_sum + even_sum) % 10


cdef char* cget_rand_numeric_str(int ndigits):
    cdef char * out = <char*> malloc((ndigits + 1) * sizeof(char))

    for i in range(ndigits):
        out[i] = rand() % 10 + 48
    out[ndigits] = 0

    return out


def get_rand_numeric_str(ndigits):
    cdef char* c_str

    try:
        c_str = cget_rand_numeric_str(ndigits)
        return c_str[:ndigits].decode('utf-8')
    finally:
        free(c_str)
