import yaml

class Workspace:

    def __init__(self, database,table_name):
        self.database = database
        self.table_name = table_name

    def get_database(self):
        return self.database
    def get_table_name(self):
        return self.table_name        

    def __str__(self):
        return "I am the tablename " + self.table_name

def workspace_constructor(loader: yaml.SafeLoader, node: yaml.nodes.MappingNode) -> Workspace:
    return Workspace(**loader.construct_mapping(node))