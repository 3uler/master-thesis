% This is nb.bst 2010/04/06 v1.02 
% A BibTeX style for fancy unsorted bibliographies in high energy physics
%
% nb.bst Copyright (C) 2003-2010 Niklas Beisert
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainer of this work is Niklas Beisert.
%
% This work consists of the files nb.bst
%

        % this work is based on BibTeX standard bibliography style `unsrt'
	% version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
	% Copyright (C) 1985, all rights reserved.
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
	% This restriction helps ensure that all standard styles are identical.
	% The file btxbst.doc has the documentation for this style.

ENTRY
  { address
    author
    archive
    booktitle
    chapter
    collaboration
    doi
    edition
    editor
    eprint
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    SLACcitation
    title
    type
    url
    volume
    year
  }
  {}
  { label }

STRINGS { s t }

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{f.~~}{vv~~}{ll}{,~jj}" format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { t "others" =
		{ " et~al." * }
		{ " and " * t * }
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {first.page}
{ 't :=
  ""
  { t empty$ not 
    t #1 #1 substring$ duplicate$ "-" = not 
                 swap$ duplicate$ "," = not 
                            swap$ "+" = not 
    and and and }
    { 
      t #1 #1 substring$ *
      t #2 global.max$ substring$ 't :=
    }
  while$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}








INTEGERS { output.state }

FUNCTION {output}
{ 
  's := 
  s empty$
    'skip$
    {
      output.state #1 =
        { ", " write$ newline$  }
        { #1 'output.state := }
      if$ 
      s write$
    }
  if$
}

FUNCTION {begin.entry}
{ 
  "\bibitem{" cite$ * "}" * write$ newline$
  #0 'output.state :=
}

FUNCTION {fin.entry}
{ 
  output.state #1 =
    { ". " write$ newline$ }
    'skip$
  if$
}

FUNCTION {output.spires}
{ 
  SLACcitation empty$
    'skip$
    { SLACcitation write$ newline$ }
  if$
}

FUNCTION {format.authors}
{ 
  collaboration empty$
    { "" }
    { collaboration " Collaboration, " * }
  if$
  author empty$
    { "" }
    { author format.names }
  if$
  *
}

FUNCTION {format.url}
{ 
  url empty$
    { "" }
    { "\href{" url * "}{\texttt{" * url * "}}" * }
  if$
}

FUNCTION {format.editor}
{ 
  editor empty$
    { "" }
    { "edited by " editor format.names * }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { "\textit{``" title * "''}" *}
  if$
}

FUNCTION {format.btitle}
{ title empty$
    { "" }
    { "\textit{``" title * "''}" *}
  if$
}

INTEGERS { tilden tildepos }

FUNCTION {puttilde}
{
  's := 
  s text.length$ 'tilden :=
  #0 'tildepos :=
  { tildepos tilden < }
  { tildepos #1 + 'tildepos := 
    s tildepos #1 substring$ " " = 
      { s #1 tildepos #1 - substring$ "~" * 
        s tildepos #1 + tilden tildepos - substring$ * 's := }
      'skip$ 
    if$
  }
  while$  
  s
}

STRINGS { nvol ndoi }

FUNCTION {format.journal}
{ 
  journal empty$
    { "" }
    { 
      volume empty$ { "no volume for journal in " cite$ * warning$ } 'skip$ if$
      pages empty$ { "no pages for journal in " cite$ * warning$ } 'skip$ if$
      year empty$ { "no year for journal in " cite$ * warning$ } 'skip$ if$

      volume 'nvol :=

      journal "JHEP" = nvol text.length$ #2 = and 
        { year #3 #2 substring$ nvol * 'nvol := }
        'skip$ 
      if$

      doi empty$ { "" } { doi } if$ 'ndoi := 

      journal "JHEP" = ndoi "" = and 
        { 
          year #1 #3 substring$ "200" = year #1 #3 substring$ "199" = or
          {
            "10.1088/1126-6708/" year * 
            "/" * nvol #3 #2 substring$ * 
            "/" * pages first.page *
            'ndoi :=
          }
          {
            "10.1007/JHEP" nvol #3 #2 substring$ * "(" * year * ")" * pages first.page *
            'ndoi :=
          }
        if$
        }
        'skip$ 
      if$

      "\textsf{" 
      ndoi "" = { } { "\doiref{" * ndoi * "}{" * } if$
      journal puttilde *
      "~" *
      nvol * 
      ",~" *
      pages first.page * 
      year empty$
        { } 
        { "~(" * year * ")" * }
      if$
      ndoi "" = { } { "}" * } if$
      "}" *
    }
  if$
}

INTEGERS { spacen spacepos }

FUNCTION { formatarxiv }
{
  's := 
  s #1 #6 substring$ "arXiv:" =
  {
    s #7 s text.length$ #6 - substring$ 's :=
  }
  'skip$ 
  if$

  s text.length$ 'spacen :=
  #0 'spacepos :=
  { spacepos spacen < }
  { spacepos #1 + 'spacepos := 
    s spacepos #1 substring$ " " = 
      { 
        spacepos #1 - 'spacen := 
        s #1 spacen substring$ 's := 
      }
      'skip$ 
    if$
  }
  while$  
  s
}

FUNCTION { arxivprefix }
{
  's := 
  s #1 #1 substring$ chr.to.int$ "0" chr.to.int$ <
  s #1 #1 substring$ chr.to.int$ "9" chr.to.int$ > + 
  'skip$ 
  {
    "arXiv:" s * 's :=
  }
  if$
  s
}

FUNCTION {format.eprint}
{ eprint empty$
    { "" }
    { "\texttt{\arxivref{" eprint formatarxiv * "}{" * eprint formatarxiv arxivprefix * "}}" * }
  if$
}

FUNCTION {format.note}
{ note empty$
    { "" }
    { note }
  if$
}

FUNCTION {format.date}
{ year empty$
    { "" }
    { " (" year * ")" *}
  if$
}

FUNCTION {format.publisher}
{ publisher empty$
    { "" }
    { publisher format.date *}
  if$
}

FUNCTION {format.address}
{ address empty$
    { "" }
    { address }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { edition "l" change.case$ " edition" * }
  if$
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages "p" * }
  if$
}

FUNCTION {do.inbook}
{ booktitle empty$
    { }
    { "in: \textit{``" booktitle * "''}" * output
      format.edition output
      format.editor output
      format.publisher output
      format.address output
      format.pages output
    }
  if$
}

FUNCTION {article}
{ 
  crossref missing$ 'skip$ { "crossref in " cite$ * warning$} if$
  author missing$ { "author missing in " cite$ * warning$} 'skip$ if$
  title missing$ journal missing$ and eprint missing$ and note missing$ and { "title, journal, eprint and note missing in " cite$ * warning$} 'skip$ if$
  begin.entry
  format.authors output
  format.title output
  format.editor output
  format.journal output
  format.eprint output
  do.inbook 
  format.note output
  format.url output
  fin.entry
  output.spires
  newline$
}

FUNCTION {book}
{
  crossref missing$ 'skip$ { "crossref in " cite$ * warning$} if$
  author missing$ { "author missing in " cite$ * warning$} 'skip$ if$
  title missing$ { "title missing in " cite$ * warning$} 'skip$ if$
  publisher missing$ { "publisher missing in " cite$ * warning$} 'skip$ if$

  begin.entry
  format.authors output
  
 format.btitle output
%  format.bvolume output
%  format.number.series output
  format.edition output
  format.publisher output
  format.address output
%  format.date output
  format.pages output
  format.note output
  fin.entry
  newline$
}



FUNCTION {default.type} { article }

READ

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "%bibliography generated by nb.bst v1.01 (C) 2003-2010 Niklas Beisert" write$ newline$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
  "\ifx\href\asklfhas\newcommand{\href}[2]{#2}\fi" write$ newline$
  "\ifx\arxivref\asklfhas\newcommand{\arxivref}[2]{\href{http://arxiv.org/abs/#1}{#2}}\fi" write$ newline$
  "\ifx\doiref\asklfhas\newcommand{\doiref}[2]{\href{http://dx.doi.org/#1}{#2}}\fi" write$ newline$
  "\raggedright" write$ newline$
  "\small" write$ newline$
  "\parskip 0pt" write$ newline$
%  "\itemsep 0pt" write$ newline$

  newline$
}

EXECUTE {begin.bib}

ITERATE {call.type$}

FUNCTION {end.bib}
{ 
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
