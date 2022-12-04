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

@i includes.w

@i defines.w

\begin{document}

@i title.w

\tableofcontents
\listoffigures

@i overview.w

@i implementation.w

@i script.w

\begin{appendix}

\chapter{Code indices}
\section{Files}
@f

\section{Fragments}
@m

\section{User identifiers}
@u

\phantomsection\listoftodos\todototoc

\cleardoublepage\phantomsection\printindex
\end{appendix}
\end{document}
