from io import StringIO
import sys
import unittest
from unittest.mock import patch
import main


def patch_output():
    captured_out = StringIO()
    sys.stdout = captured_out
    return captured_out

def unpatch_output(): 
    sys.stdout = sys.__stdout__ # reset to normal stdout  

class TestClientApp(unittest.TestCase):

    @patch('mydb.CountyResult.select')
    def test_get_county_stats(self, mock_db_access):        
        # Have the select() method simply return a value of 1
        mock_db_access.side_effect = 1
            
        # Test it works when user input is an integer
        with patch('builtins.input', return_value="1"):
            captured_out = patch_output()
            main.get_county_stats()
            assert captured_out.getvalue() == 1

            unpatch_output()