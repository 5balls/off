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

\chapter{Overview}
\verb|off| is a python script for downloading content of the internet for offline consumption. This is to avoid ``doom scrolling'' by purposefully adding ressources you want to follow in its configuration and the script taking care of downloading that content on the computer thus avoiding the need to use an internet browser as often.

The script is written for a typical linux environment and may not work that well on other operating systems (though it may probably be possible to make it work there as well, as everything used is open source).

\section{Usage}

In the following sections different usage scenarios are shown.

\subsection{off without arguments}

If \verb|off| is run without arguments, it will check for the existance of the \verb|~/.off| directory and a file \verb|config.json| in there. If this file is found it is read and for each ressource there will be a check for updates. Any updates will be downloaded and an entry added to \verb|~/.off/new.json|.

\subsection{off new}

If \verb|off| is run with the \verb|new| argument, it will first update the ressources and then show the list of entries in \verb|~/.off/new.json| with preceding numbers.

@d Add commands to parser
@{@%
command_parser.add_parser("new", help="Show new entries")
@}

\subsection{off download}

If \verb|off| is run with the \verb|download| argument it will download the entry given by the number (corresponding to the number shown by the new command).

@d Add commands to parser
@{@%
download_parser = command_parser.add_parser("download", help="Download entry")
download_parser.add_argument("number",type=int)
@}

\subsection{off ignore}

If \verb|off| is run with the \verb|ignore| argument it will remove the entry given by the number from the new list.

@d Add commands to parser
@{@%
ignore_parser = command_parser.add_parser("ignore", help="Remove entry from new list")
ignore_parser.add_argument("number",type=int)
@}

\subsection{off available}

If \verb|off| is run with the \verb|available| argument it will show all downloaded entries.
@d Add commands to parser
@{@%
command_parser.add_parser("available", help="Show downloaded entries")
@}

\subsection{off view}

If \verb|off| is run with the \verb|view| argument it will run a program on the latest unwatched entry in the given ressource. The entry will be removed from the \verb|new.json| file.

\begin{itemize}
\item [] Without another argument it will show the oldest new entry.
\item [\textless number\textgreater] With a number it will show the new entry with the number shown by the latest call of \verb|off new|.
\item [search] The new entries will be searched for the following text and if there is a match the oldest entry will be shown. If there is no match but there is a match in older entries the newest of the older entries will be shown.
\item [category] The new entries will be searched for being in this category. Behaviour is otherwise the same as with \verb|search|.
\end{itemize}

@d Add commands to parser
@{@%
view_parser = command_parser.add_parser("view", help="Run command associated with entry")
view_parser.add_argument("number",type=int,nargs="?")
#view_subparser = view_parser.add_subparsers(dest="subcommand")
#view_subparser.add_parser("search")
#view_subparser.add_parser("category")
@}

Search and category are not implemented yet.

\subsection{off delete}

If \verb|off| is run with the \verb|delete| argument it will remove the entry given by the number from the available list.

@d Add commands to parser
@{@%
delete_parser = command_parser.add_parser("delete", help="Remove entry from available list")
delete_parser.add_argument("number",type=int)
@}

\section{Dependencies}

In order to run \verb|off| you might need to install some dependencies. \verb|off| depends on some python libraries which can be installed from the ``Python Package Index'' (PyPI) by running the command \verb|pip install <library>|.

\subsection{argparse}

We go the easy route and just use the \verb|argparse| library to parse the command line arguments.

@d Python library imports
@{import argparse
@}

\subsection{os}

Os is needed to check for the existance of directories and files.

@d Python library imports
@{import os
@| os @}

\subsection{json}

Json is needed to read and write json files. 

@d Python library imports
@{import json
@| json @}

\subsection{jsonpickle}

Jsonpickle is used to serialize from / to json.

@d Python library imports
@{import jsonpickle
@| jsonpickle @}

\subsection{jsonschema}

This library is used to validate the json files against our schemas.

@d Python library imports
@{import jsonschema
@| jsonschema @}

\subsection{feedparser}

Feedparser is used to get a syndicated news feed. It can handle RSS and atom.

@d Python library imports
@{import feedparser
@| feedparser @}

\subsection{calendar}

Calendar is used to convert the struct given from the feedparser library to an epoch timestamp which is easier to handle.

@d Python library imports
@{import calendar
@| calendar @}

\subsection{hashlib}

This library is used to create a md5sum hash from the id to have a directory handle.

@d Python library imports
@{import hashlib
@| hashlib @}

\subsection{youtube\_dl}

Youtube\_dl is used to download youtube videos

@d Python library imports
@{import yt_dlp
@| yt_dlp @}

\subsection{subprocess}

Subprocess is used to call different viewer programs.

@d Python library imports
@{import subprocess
@| subprocess @}

\subsection{fnmatch}

Fnmatch is used to finde the youtube downloads for which we don't know the file extension.

@d Python library imports
@{import fnmatch
@| fnmatch @}
