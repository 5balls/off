% Copyright 2022 Florian Pesth
%
% This file is part of off.
%
% off is free software: you can redistribute it and/or modify
% it under the terms of the GNU Affero General Public License as
% published by the Free Software Foundation version 3 of the
% License.
%
% off is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Affero General Public License for more details.
%
% You should have received a copy of the GNU Affero General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

\chapter{Implementation}

\section{Class Off}
@d \classDeclaration{Off}
@{@%
class Off:
    version = "0.1"
    basepath = os.path.expanduser("~/.off")

    def __init__(self):
        self.parseArguments()
        self.readConfig()

    def main(self):
        if self.args.command == None:
            self.getNewEntriesAndWriteThemToFile()
        if self.args.command == "new":
            self.showNewEntries()
        if self.args.command == "download":
            if len(self.entries) < self.args.number:
                print("There are less than " + str(self.args.number) + " new entries!")
            else:
                self.entries[self.args.number-1].download()
                self.availableEntries.append(self.entries[self.args.number-1])
                self.entries.pop(self.args.number-1)
        if self.args.command == "ignore":
            if len(self.entries) < self.args.number:
                print("There are less than " + str(self.args.number) + " new entries!")
            else:
                self.entries.pop(self.args.number-1)
                self.showNewEntries()
        if self.args.command == "available":
            self.showAvailableEntries()
        if self.args.command == "view":
            if self.args.number != None:
                if len(self.availableEntries) < self.args.number:
                    print("There are less than " + str(self.args.number) + " available entries!")
                else:
                    self.availableEntries[self.args.number-1].view()
        if self.args.command == "delete":
            if len(self.availableEntries) < self.args.number:
                print("There are less than " + str(self.args.number) + " available entries!")
            else:
                self.availableEntries[self.args.number-1].delete()
                self.availableEntries.pop(self.args.number-1)
                self.showAvailableEntries()
        self.ressources.writeFile()
        file = open(os.path.join(self.basepath,"new_entries.json"), "w")
        file.write(jsonpickle.encode(self.entries))
        file.close()
        file = open(os.path.join(self.basepath,"available.json"), "w")
        file.write(jsonpickle.encode(self.availableEntries))
        file.close()

    @<\classImplementation{Off}@>

if __name__ == '__main__':
    myOff = Off()
    myOff.main()
@| Off @}

\subsection{parseArguments}
\indexClassMethod{Off}{parseArguments}
@d \classImplementation{Off}
@{@%
def parseArguments(self):
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--version", action="version", version=self.version)
    command_parser = parser.add_subparsers(dest='command')
    @<Add commands to parser@>
    self.args = parser.parse_args()        
@| parseArguments @}

\subsection{readConfig}
\indexClassMethod{Off}{readConfig}
@d \classImplementation{Off}
@{@%
def readConfig(self):
    if not os.path.exists(self.basepath):
        print("Configuration directory does not exist, creating \"~/.off\"")
        os.mkdir(self.basepath)
    if not os.path.exists(os.path.join(self.basepath,"downloads")):
        print("Download directory does not exist, creating \"~/.off/downloads\"")
        os.mkdir(os.path.join(self.basepath,"downloads"))
    self.ressources = Ressources(os.path.join(self.basepath,"ressources.json"))
    if os.path.exists(os.path.join(self.basepath,"new_entries.json")):
        file = open(os.path.join(self.basepath,"new_entries.json"), "r")
        self.entries = jsonpickle.decode(file.read())
        file.close()
    else:
        self.entries = []
    if os.path.exists(os.path.join(self.basepath,"available.json")):
        file = open(os.path.join(self.basepath,"available.json"), "r")
        self.availableEntries = jsonpickle.decode(file.read())
        file.close()
    else:
        self.availableEntries = []


@| readConfig @}

\subsection{getNewEntriesAndWriteThemToFile}
\indexClassMethod{Off}{getNewEntriesAndWriteThemToFile}
@d \classImplementation{Off}
@{@%
def getNewEntriesAndWriteThemToFile(self):
    self.entries += self.ressources.getEntries()
    file = open(os.path.join(self.basepath,"new_entries.json"), "w")
    file.write(jsonpickle.encode(self.entries))
    file.close()
@| getNewEntriesAndWriteThemToFile @}

\subsection{showNewEntries}
\indexClassMethod{Off}{showNewEntries}
@d \classImplementation{Off}
@{@%
def showNewEntries(self):
    entrynumber = 1
    for entry in self.entries:
        entry.print(entrynumber)
        entrynumber += 1
@| showNewEntries @}

\subsection{showAvailableEntries}
\indexClassMethod{Off}{showAvailableEntries}
@d \classImplementation{Off}
@{@%
def showAvailableEntries(self):
    entrynumber = 1
    for entry in self.availableEntries:
        entry.print(entrynumber)
        entrynumber += 1
@| showAvailableEntries @}

\section{Class Ressources}
@d \classDeclaration{Ressources}
@{@%
class Ressources:

    def __init__(self, jsonFileName):
        self.ressources = []
        self.jsonFileName = jsonFileName
        self.readFile()

    @<\classImplementation{Ressources}@>
@| Ressources @}

\subsection{readFile}
\indexClassMethod{Ressources}{readFile}
@d \classImplementation{Ressources}
@{@%
def readFile(self):
    if not os.path.exists(self.jsonFileName):
        print("File \"" + self.jsonFileName + "\" does not exist, creating an example file at its place!")
        self.createExampleFile()
        return
    else:
        file = open(self.jsonFileName, "r")
        jsonString = file.read()
        jsonSchema = {
          "$schema": "https://json-schema.org/draft/2019-09/schema",
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "py/object": {
                "type": "string",
                "enum": [
                  "__main__.Ressource"
                ]
              },
              "id": {
                "type": "string"
              },
              "feed": {
                "type": "string"
              },
              "type": {
                "type": "string",
                "enum": [
                  "youtube"
                ]
              },
              "lastfetched": {
                "type": "number"
              }
            },
            "additionalProperties": False,
            "required": [
              "py/object",
              "id",
              "feed",
              "type",
              "lastfetched"
            ]
          }
        }
        jsonObject = json.loads(jsonString)
        jsonschema.validate(instance=jsonObject, schema=jsonSchema)
        self.ressources = jsonpickle.decode(jsonString)
        file.close()
        return
@| readFile @}

\subsection{createExampleFile}
\indexClassMethod{Ressources}{createExampleFile}
@d \classImplementation{Ressources}
@{@%
def createExampleFile(self):
    self.ressources.append(Ressource('{"id": "Tom Scott", "feed": "https://www.youtube.com/feeds/videos.xml?channel_id=UCBa659QWEk1AI4Tg--mrJ2A", "type": "youtube", "lastfetched": 0}'))
@| createExampleFile @}

\subsection{writeFile}
\indexClassMethod{Ressources}{writeFile}
@d \classImplementation{Ressources}
@{@%
def writeFile(self):
    file = open(self.jsonFileName, "w")
    file.write(jsonpickle.encode(self.ressources))
    file.close()
@| writeFile @}

\subsection{getEntries}
\indexClassMethod{Ressources}{getEntries}
@d \classImplementation{Ressources}
@{@%
def getEntries(self):
    entries = []
    for ressource in self.ressources:
        entries += ressource.getEntries()
    return entries
@| getEntries @}

\section{Class Ressource}
@d \classDeclaration{Ressource}
@{@%
class Ressource:
    def __init__(self,jsonString):
        self.__dict__ = jsonpickle.decode(jsonString)

    @<\classImplementation{Ressource}@>
@| Ressource @}

\subsection{getEntries}
\indexClassMethod{Ressource}{getEntries}
@d \classImplementation{Ressource}
@{@%
def getEntries(self):
    entries = []
    latestFeed = feedparser.parse(self.feed)
    latest_fetched = 0
    for entry in latestFeed.entries:
        epoch = calendar.timegm(entry.published_parsed)
        if epoch > self.lastfetched:
            print("Fetching \"" + entry.title + "\"")
            entries.append(Entry(self.id,entry.title,entry.id,epoch,entry.link,self.type))
            if epoch > latest_fetched:
                latest_fetched = epoch
    if latest_fetched > self.lastfetched:
        self.lastfetched = latest_fetched
        print("Updated feed from \"" + self.id + "\"")
    return entries
@| getEntries @}

\section{Class Entry}
@d \classDeclaration{Entry}
@{@%
class Entry:
    def __init__(self,feedid,title,id,published,link,type):
        self.feedid = feedid
        self.title = title
        self.id = id
        self.published = published
        self.link = link
        self.type = type

    @<\classImplementation{Entry}@>
@| Entry @}

\subsection{download}
\indexClassMethod{Entry}{download}
@d \classImplementation{Entry}
@{@%
def download(self):
    if not os.path.exists(os.path.join(os.path.expanduser("~/.off/downloads"), self.feedid)):
        os.mkdir(os.path.join(os.path.expanduser("~/.off/downloads"), self.feedid))
    if self.type == "youtube":
        ydl_opts = {
        'format': 'best',
        'outtmpl': '~/.off/downloads/' + self.feedid + '/' + hashlib.md5(self.id.encode('utf-8')).hexdigest() + '.%(ext)s',
        }
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([self.link])
@| download @}

\subsection{view}
\indexClassMethod{Entry}{view}
@d \classImplementation{Entry}
@{@%
def view(self):
    if self.type == "youtube":
        candidates = os.listdir(os.path.join(os.path.expanduser("~/.off/downloads"),self.feedid))
        files = fnmatch.filter(candidates, hashlib.md5(self.id.encode('utf-8')).hexdigest() + ".*")
        for file in files:
            subprocess.call(['vlc',os.path.join(os.path.expanduser("~/.off/downloads"),self.feedid,file)])
@| view @}

\subsection{delete}
\indexClassMethod{Entry}{delete}
@d \classImplementation{Entry}
@{@%
def delete(self):
     if self.type == "youtube":
        candidates = os.listdir(os.path.join(os.path.expanduser("~/.off/downloads"),self.feedid))
        files = fnmatch.filter(candidates, hashlib.md5(self.id.encode('utf-8')).hexdigest() + ".*")
        for file in files:
            fullfilename = os.path.join(os.path.expanduser("~/.off/downloads"),self.feedid,file)
            if os.path.isfile(fullfilename):
                os.remove(fullfilename)
@| delete @}

\subsection{print}
\indexClassMethod{Entry}{print}
@d \classImplementation{Entry}
@{@%
def print(self,entrynumber):
    if(self.type == "youtube"):
        typesymbol = "🎥 "
    else:
        typesymbol = ""
    print(str(entrynumber) + " " + typesymbol + self.feedid + " \"" + self.title + "\"")
@| print @}
