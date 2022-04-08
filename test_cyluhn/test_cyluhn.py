import sys, os
import unittest

import pyximport; pyximport.install()

sys.path.append(os.path.abspath(os.path.join(__file__, '../../src')))
import cyluhn


INVALID_INPUT_NON_NUMERIC = '123abc'
INVALID_INPUT_UNICODE = '123ü'

INVALID_INPUTS = [INVALID_INPUT_NON_NUMERIC,
                  INVALID_INPUT_UNICODE,
                  None,
                  '']


class CyluhnTests(unittest.TestCase):

    def test_verify_invalid_inputs(self):
        for str_in in INVALID_INPUTS:
            self.assertFalse(cyluhn.verify(str_in))

    def test_checkdigit_raise_valueerror(self):
        for str_in in INVALID_INPUTS:
            with self.assertRaises(ValueError):
                cyluhn.get_check_digit(str_in)

    def test_append_raise_valueerror(self):
        for str_in in INVALID_INPUTS:
            with self.assertRaises(ValueError):
                cyluhn.append_check_digit(str_in)


if __name__ == '__main__':
    unittest.main()
