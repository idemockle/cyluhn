from libc.stdio cimport printf
from libc.string cimport strcpy
from libc.stdlib cimport atoi, div, div_t, malloc, free

def say_hello_to(name):
    print("Hello %s!" % name)


def do_printf(string):
    cdef char* cstring = convert_to_cstr(string)
    printf('%s', cstring)
    free(cstring)

cdef char* convert_to_cstr(str pystr):
    cdef char* cstring = <char *> malloc((len(pystr)+1) * sizeof(char))
    strcpy(cstring, bytes(pystr, 'ascii'))
    return cstring

# def checksum(string):
#     cdef char* cstring = <char *> malloc((len(string)+1) * sizeof(char))
#     strcopy(cstring, string)
#     try:
#         out = cchecksum(cstring, len(string))
#         return out
#     finally:
#         free(cstring)
#
#
# cdef int cchecksum(char *string, Py_ssize_t stringsize):
#     cdef div_t even_div
#     cdef bint is_odd = 1
#     cdef int odd_sum = 0
#     cdef int even_sum = 0
#     cdef char zero = 48 # '0' char
#     for i in range(stringsize, -1, -1):
#         if is_odd:
#             odd_sum += string[i] - zero
#         else:
#             even_div = div(2*(string[i] - zero), 10)
#             even_sum += even_div.quot + even_div.rem
#         is_odd = not is_odd
#     return (odd_sum + even_sum) % 10
    # digits = list(map(int, string))
    # odd_sum = sum(digits[-1::-2])
    # even_sum = sum([sum(divmod(2 * d, 10)) for d in digits[-2::-2]])
    # return (odd_sum + even_sum) % 10

# def checksum(string):
#     """
#     Compute the Luhn checksum for the provided string of digits. Note this
#     assumes the check digit is in place.
#     """
#     digits = list(map(int, string))
#     odd_sum = sum(digits[-1::-2])
#     even_sum = sum([sum(divmod(2 * d, 10)) for d in digits[-2::-2]])
#     return (odd_sum + even_sum) % 10