from abc import ABC, abstractmethod
 
class Location(ABC):
 

    @abstractmethod
    def readConfigFile(self):
        pass   