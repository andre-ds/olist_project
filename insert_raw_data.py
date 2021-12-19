import os
from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine
import documents as dc
from PreProcessing import InsertData

# Defining Environment
load_dotenv()
PATH_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath('__file__'))), 'data')

## Insert data
connection = create_engine(os.getenv('connection'))
insert = InsertData(conexao=connection, path=PATH_DIR)

# Insert Dataset's
for i in dc.dictionary_data:
    insert.load_dataset(filename=dc.dictionary_data.get(
        i), tabela=i, schema='olist', tipo='append')