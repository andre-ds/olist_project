import os
import pandas as pd


class InsertData:

    def __init__(self, conexao, path):
        self.conexao = conexao
        self.path = path

    def load_dataset(self, filename, tabela, schema, tipo):

        # Abrir Dataset
        dataset = pd.read_csv(os.path.join(self.path, filename), sep=',')
        # Inserir Dado
        print('Inserting:', tabela.title())
        dataset.to_sql(name=tabela,
                       con=self.conexao,
                       schema=schema,
                       if_exists=tipo,
                       index=False)

class PreProcessing:

    def initial_analysis(self, dataset):
        dataset = pd.DataFrame({'Tipo': dataset.dtypes,
                                'Quantidade_Nan': dataset.isna().sum(),
                                'Percentual_Nan': (dataset.isna().sum() / dataset.shape[0]) * 100,
                                'Valores_Unicos': dataset.nunique()})
        return dataset