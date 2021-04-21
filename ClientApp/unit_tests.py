from io import StringIO
import sys
import unittest
from unittest.mock import patch
import main as main


def patch_output():
    captured_out = StringIO()
    sys.stdout = captured_out
    return captured_out


def unpatch_output():
    sys.stdout = sys.__stdout__  # reset to normal stdout


# class TestClientApp(unittest.TestCase):
#
#     @patch('mydb.CountyResult.select')
#     @patch('main.get_input_as_int')
#     def test_get_county_stats(self, mock, mock_db_access):
#         # Have the select() method simply return a value of 1
#         mock_db_access.side_effect = 1
#         mock.side_effect = [1, 2016, 0]
#         # Test it works when user input is an integer
#         with patch('builtins.input', return_value="1"):
#             captured_out = patch_output()
#             main.get_county_stats()
#             assert captured_out.getvalue() == 1
#
#             unpatch_output()


class TestUserInput(unittest.TestCase):
    @patch('main.get_input', return_value="STRING")
    def test_input_as_int_invalid(self, input):
        self.assertEqual(main.get_input_as_int("STRING"), -1)

    @patch('main.get_input', return_value=1234)
    def test_input_as_int_valid(self, input):
        self.assertEqual(main.get_input_as_int("STRING"), 1234)

    @patch('main.get_input', return_value="STRING")
    def test_input_as_str_valid(self, input):
        self.assertEqual(main.get_input_as_str("STRING"), "STRING")

    @patch('main.get_input', return_value=1234)
    def test_input_as_str_invalid(self, input):
        self.assertEqual(main.get_input_as_str("STRING"), -1)

