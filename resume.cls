%%
%% Copyright (c) 2018 Weitian LI
%% Copyright (c) 2016 Christophe Roger
%%
%% Resume LaTeX template.
%% Based on
%%     YACC: Another Awesome CV by Christophe Roger
%%     https://github.com/darwiin/yaac-another-awesome-cv
%% which is further based on
%%     Plasmati Graduate CV by Alessandro Plasmati
%%     https://www.latextemplates.com/template/plasmati-graduate-cv
%%

\ProvidesClass{resume}[2018/04/11 v2.0.0 'Resume' Class]
\LoadClass[a4paper]{article}

%%
%% Class options
%%

\DeclareOption{monochrome}{\def\@monochrome{true}}
\DeclareOption{zh}{\def\@zh{true}}

\ProcessOptions

%%
%% Packages
%%

\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{fontspec}
\RequirePackage{fontawesome}
\RequirePackage{parskip}
\RequirePackage{fullpage}
\RequirePackage[margin=1.5cm]{geometry}
\RequirePackage{titlesec}
\RequirePackage{setspace}
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{longtable}
\RequirePackage[usenames,dvipsnames]{xcolor}
\RequirePackage[skins]{tcolorbox}
\RequirePackage{tikz}
\RequirePackage{xeCJK}
\RequirePackage{ulem}
\RequirePackage{CJKulem}
\RequirePackage{csquotes}

%
% Hyperref
%
% Delay the execution of \hypersetup at \begin{document}.
% NOTE: Should be set before hyperref uses it.
\AtBeginDocument{%
  \hypersetup{%
    pdfborder={0 0 0},% No border around links
    pdfauthor={%
      \ifdef{\@zh}{%
        \@lastname{} \@firstname%
      }{%
        \@firstname{} \@lastname%
      }%
    },%
    pdftitle={%
      \ifdef{\@zh}{%
        简历 | \@lastname{} \@firstname{} | \@tagline%
      }{%
        Resume | \@firstname{} \@lastname{} | \@tagline%
      }%
    },%
    pdfsubject={\@tagline},%
    pdfkeywords={\@keywords},%
  }%
}
\RequirePackage{hyperref}

%%
%% General settings
%%

% Fonts
\defaultfontfeatures{Mapping=tex-text}
\setmainfont{TeX Gyre Pagella}
\setsansfont{Roboto}
\setmonofont{M+ 1mn}

% Chinese setup
\xeCJKsetup{PunctStyle=hangmobanjiao}
\setCJKmainfont{Noto Serif CJK SC}[BoldFont=Noto Sans CJK SC]
\setCJKsansfont{Noto Sans CJK SC}
\setCJKmonofont{Noto Sans Mono CJK SC}

% Color setup
\ifdef{\@monochrome}%
  {\definecolor{basecolor}{HTML}{000000}}%
  {\definecolor{basecolor}{HTML}{000066}}  % blue
%
\definecolor{darkGrey}{HTML}{989898}
%
\colorlet{linkcolor}{basecolor}
\colorlet{accentcolor}{linkcolor!90}
\colorlet{symbolcolor}{linkcolor!85}

% Font Awesome icons aliases
\newcommand*{\birthdaySymbol}{\faBirthdayCake}
\newcommand*{\degreeSymbol}{\faGraduationCap}
\newcommand*{\githubSymbol}{\faGithub}
\newcommand*{\homeSymbol}{\faHome}
\newcommand*{\infoSymbol}{\faInfoCircle}
\newcommand*{\mailSymbol}{\faEnvelope}
\newcommand*{\mobileSymbol}{\faPhone}  % \faMobilePhone is too narrow
\newcommand*{\linkedinSymbol}{\faLinkedin}
\newcommand*{\locationSymbol}{\faMapMarker}
\newcommand*{\phoneSymbol}{\faPhone}
\newcommand*{\universitySymbol}{\faUniversity}

% Date format: yyyy.mm.dd
\newcommand*{\twodigits}[1]{\ifnum#1<10 0\fi\the#1}
\renewcommand*{\today}{%
  \leavevmode\hbox{\the\year.\twodigits\month.\twodigits\day}
}

% Non-numbered pages
\pagestyle{empty}

% Last-page style
\def\ps@lastpage{%
  \def\@oddfoot{\textcolor{lightgray}{\footnotesize\@fileinfo}\hfil}%
  \def\@evenfoot{\textcolor{lightgray}{\footnotesize\@fileinfo}\hfil}%
}
\AtEndDocument{\thispagestyle{lastpage}}

% Line spacing
\linespread{1.1}

% Setup resume sections
\titleformat{\section}{\Large\raggedright}{}{0.2em}{}[\titlerule]
\titlespacing{\section}{0em}{0.2em}{0.2em}

% Configure list via 'enumitem'
\setlist[itemize,1]{label=\faAngleRight, nosep, leftmargin=2em}
\setlist[description,1]{style=sameline}

% New length definition
\newlength{\leftcolwidth}
\setlength{\leftcolwidth}{6em}
\newlength{\rightcolwidth}
\setlength{\rightcolwidth}{\dimexpr \textwidth - \leftcolwidth - 4\tabcolsep}

%%
%% Generic commands
%%

\newcommand*{\creativecommons}[2]{%
  \href{http://creativecommons.org/licenses/#1/#2/}%
    {\faCreativeCommons{} \uppercase{#1} #2}%
}

\newcommand*{\link}[2]{\textcolor{linkcolor}{\href{#1}{#2}}}
\newcommand*{\important}[1]{\textbf{#1}}

% Render an icon
\newcommand*{\icon}[1]{%
  \makebox[1em][c]{\textcolor{symbolcolor}{#1}}%
  \hspace{0.5em}%
}

% Test whether the command argument is given and is not empty
% Credit: https://tex.stackexchange.com/a/63233
\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\IfNoValueOrEmptyTF}{mmm}{%
  \IfNoValueTF{#1}{#2}{%
    \tl_if_empty:nTF {#1} {#2} {#3}
  }
}
\ExplSyntaxOff

%%
%% Tags
%%

% Create a tag: \tag{<label>}
\newcommand*{\tag}[1]{%
  \tikz[baseline]
  \node[anchor=base,
        draw=accentcolor!60,
        rounded corners=0.5ex,
        inner xsep=0.8ex,
        inner ysep=0.5ex,
        text height=1.6ex,
        text depth=0.4ex]{#1};
}

\newcommand*{\tags}[1]{%
  \icon{\faTags}
  \foreach \n in {#1}{\tag{\n}\hspace{0.1em}}
}

%%
%% Header
%%

% Render a text with its symbol
% Usage; \socialtext{<icon>}{<label>}
\newcommand*{\socialtext}[2]{%
  \mbox{\icon{#1} #2 \hspace{1em}}%
}

% Render a link with its symbol
% Usage; \sociallink{<icon>}{<label>}
\newcommand*{\sociallink}[3]{%
  \mbox{\icon{#1} \link{#2}{#3} \hspace{1em}}%
}

% Name: \name{<firstname>}{<lastname>}
\newcommand*{\name}[2]{\def\@firstname{#1}\def\@lastname{#2}}
% Tag line
\newcommand*{\tagline}[1]{\def\@tagline{#1}}
\newcommand*{\taglineicon}[1]{\def\@taglineicon{#1}}
% Keywords
\newcommand*{\keywords}[1]{\def\@keywords{#1}}
% File information
\newcommand*{\fileinfo}[1]{\def\@fileinfo{#1}}

% Photo: \photo{<diameter>}{<photo>}
\newcommand{\photo}[2]{\def\@photo{#2}\def\@photodiameter{#1}}

% Address
\newcommand*{\address}[1]{\socialtext{\locationSymbol}{#1}}
% Birthday
\newcommand*{\birthday}[1]{\socialtext{\birthdaySymbol}{#1}}
% Place of birth
\newcommand*{\home}[1]{\socialtext{\homeSymbol}{#1}}
% Information
\newcommand*{\info}[1]{\socialtext{\infoSymbol}{#1}}
% Mobile phone
\newcommand*{\mobile}[1]{\socialtext{\mobileSymbol}{#1}}
% Phone
\newcommand*{\phone}[1]{\socialtext{\phoneSymbol}{#1}}
% Degree
\newcommand*{\degree}[1]{\socialtext{\degreeSymbol}{#1}}
% University
\newcommand*{\university}[1]{\socialtext{\universitySymbol}{#1}}

% LinkedIn: \linkedin{<username>}
\newcommand*{\linkedin}[1]{%
  \sociallink{\linkedinSymbol}%
    {http://www.linkedin.com/in/#1}%
    {linkedin.com/in/#1}%
}
% GitHub: \github{<username>}
\newcommand*{\github}[1]{%
  \sociallink{\githubSymbol}%
    {https://github.com/#1}%
    {\texttt{github.com/#1}}%
}
% Email address
\newcommand*{\email}[1]{%
  \sociallink{\mailSymbol}{mailto:#1}{\texttt{#1}}
}

% Render the tagline
\newcommand*{\resumetitle}[1]{%
  \color{accentcolor}{\textbf{\large{#1}}}
}
% Render the name: \user{<firstanme>}{<lastname>}
\newcommand*{\user}[2]{%
  \color{accentcolor}{%
    \ifdef{\@zh}%
      {{\LARGE\bfseries #2 #1}}%
      {{\LARGE\bfseries #1 \textsc{#2}}}%
}}

% Define social entries to print in header
\newcommand*{\socialinfo}[1]{\def\@socialinfo{#1}}

% Render resume header
\newcommand*{\makeheader}{
  \ifdef{\@photodiameter}{
    \begin{minipage}{\@photodiameter}
      \tikz\path[fill overzoom image={\@photo}]
        circle[radius=0.5\linewidth];
    \end{minipage}
  }{}
  \hspace{1em}
  \ifundef{\@photodiameter}{%
    \begin{minipage}{\linewidth}
  }{%
    \begin{minipage}{\dimexpr\linewidth-\@photodiameter-2em}
  }
    \onehalfspacing
    \user{\@firstname}{\@lastname}
    \smallskip \\
    \ifdef{\@taglineicon}{%
      \resumetitle{\icon{\@taglineicon}\@tagline}
    }{%
      \resumetitle{\@tagline}
    }
    \smallskip \\
    \@socialinfo
  \end{minipage}
  \bigskip
}

%%
%% Sections
%%

% Title
\newcommand*{\sectionTitle}[2]{%
  \section{%
    \texorpdfstring%
      {\color{accentcolor}{\icon{#2} \textbf{#1}}}%
      {#1}%
  }
}

% Extra array column types
% Credit: https://tex.stackexchange.com/a/12712
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}

% Basic entries listing
\NewDocumentEnvironment{entries}{o}{%
  \IfValueTF{#1}%
    {\begin{tabular}{R{\leftcolwidth} #1 L{\rightcolwidth}}}%
    {\begin{tabular}{R{\leftcolwidth} L{\rightcolwidth}}}%
}{%
  \end{tabular}
}

\NewDocumentCommand{\entry}{m m}{
  #1 & \begin{minipage}[t]{\rightcolwidth} #2 \end{minipage} \\
}

% Separator (empty space) between two entries
\newcommand*{\separator}[1]{%
  \multicolumn{2}{c}{} \\[\dimexpr #1 - 1em]
}

%%
%% Section: competences
%%

% \begin{competences}[width]
\NewDocumentEnvironment{competences}{o}{%
  \IfValueTF{#1}{%
    \begin{tabular}{R{#1} L{\dimexpr \textwidth - #1 - 4\tabcolsep}}
  }{%
    \begin{tabular}{R{\leftcolwidth} L{\rightcolwidth}}
  }
}{%
  \end{tabular}
}

\NewDocumentCommand{\comptence}{m m}{
  \textbf{#1} & #2 \\
}

%%
%% Section: educations
%%

\NewDocumentEnvironment{educations}{}{%
  \begin{tabular}{R{\leftcolwidth} | L{\rightcolwidth}}
}{%
  \end{tabular}
}

% \education
%   {<start-date>}  % #1
%   {<end-date>}    % #2
%   {<school>}      % #3
%   {<department>}  % #4
%   {<major>}       % #5
%   {<degree>}      % #6
\NewDocumentCommand{\education}{m m m m m m}{
  #2 & \textbf{#3} \textbullet #4 \\*
  #1 & #5 \textbullet #6 \\
}

%%
%% Section: projects
%%

\NewDocumentEnvironment{projects}{}{%
  \begin{longtable}{R{\leftcolwidth} | L{\rightcolwidth}}
}{%
  \end{longtable}
}

% \project
%   {<start-date>}   % #1
%   {<end-date>}     % #2
%   {<department>}   % #3
%   {<type>}         % #4
%   {<name>}         % #5
%   {<description>}  % #6
%   [<tags>]         % #7
\NewDocumentCommand{\project}{m m m m m m o}{
  #2 & \textbf{#5} \\*
  #1 & #3 \textbullet #4 \\
     & \begin{minipage}[t]{\rightcolwidth}
         #6
       \end{minipage} \\*
  \IfValueT{#7}{%
    & \footnotesize{\tags{#7}} \\
  }
}

%%
%% Section: experiences
%%

\NewDocumentEnvironment{experiences}{}{%
  \begin{longtable}{R{\leftcolwidth} | L{\rightcolwidth}}
}{%
  \end{longtable}
}

% \experience
%   [<start-date>]   % #1
%   {<end-date>}     % #2
%   {<summary>}      % #3
%   [<description>]  % #4
%   [<tags>]         % #5
\NewDocumentCommand{\experience}{o m m o o}{
  #2 & #3 \\*
  \IfValueT{#1}{#1}
  \IfNoValueOrEmptyTF{#4}{}{%
     & \begin{minipage}[t]{\rightcolwidth}
         #4
       \end{minipage} \\*
  }
  \IfValueT{#5}{%
    & \footnotesize{\tags{#5}} \\
  }
}

%%
%% Two-column section
%%

\newcommand*{\twocolumnsection}[2]{
  \begin{minipage}[t]{\dimexpr(\linewidth/2) - 3em}
    #1
  \end{minipage}
  \hfill
  \begin{minipage}[t]{\dimexpr(\linewidth/2) - 3em}
    #2
  \end{minipage}
}

%%
%% Section: skills
%%

\NewDocumentEnvironment{skills}{}{%
  \begin{tabular}{R{\leftcolwidth} L{\rightcolwidth}}
}{%
  \end{tabular}
}

\NewDocumentCommand{\skill}{m m}{
  \textbf{#1} &
    \foreach \x in {1,...,5}{%
      \color{accentcolor!80}{%
        \ifnumgreater{\x}{#2}{\faCircleThin}{\faCircle}
      }
    } \enspace \\
}

%%
%% Section: referees
%%

\newenvironment{referees}{%
}{%
  \hfill
  \bigskip
}

\newcommand*{\referee}[5]{%
  \hspace{1em}
  \begin{minipage}[t]{\dimexpr(\linewidth/3) - 3em}
    \begin{tabular}{>{}l >{}l}
      \multicolumn{2}{l}{\textbf{#1}}\\
      \multicolumn{2}{l}{\emph{#2}, \textsc{#3}}\\
      \quad \mailSymbol & \href{mailto:#4}{#4} \\
      \quad \phoneSymbol & #5 \\
    \end{tabular}
  \end{minipage}%
}

%% EOF