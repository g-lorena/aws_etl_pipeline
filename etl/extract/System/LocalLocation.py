from pathlib import Path
import sys
path_root = Path(__file__).parents[0]
sys.path.append(str(path_root))
print(sys.path)


from location import Location 
from workspace import Workspace

import workspace
import yaml
from pathlib import Path
import shutil


class LocalLocation(Location):
   
    def get_Configloader(self):
        loader = yaml.SafeLoader
        loader.add_constructor("!Workspace", workspace.workspace_constructor)
        return loader

    def readConfigFile(self,location):
        data = yaml.load(open(location, "rb"), Loader=self.get_Configloader())
        works = []
        list_Works = data["Workspaces"]
        for o in list_Works:
            database = Path(o.database)
            table_name = Path(o.table_name)
            if database.exists() & database.is_dir() & table_name.exists() & table_name.is_dir():
                works.append(Workspace(o.database,o.table_name))   
        return list_Works
    
    def moveFile(self, src, dst):
        shutil.move(src, dst)