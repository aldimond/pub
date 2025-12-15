\version "2.24.4"

octoHints = #(define-music-function (offs mus) (integer? ly:music?)
  "Adds 'hint' notes to @var{mus}, @var{offs} octaves above/below notes
as-written.  This is an arguably goofy alternative to clef-changes or
ottava. It only works on sequential music or single notes, and only in
relative mode.
"
  (cond ((music-is-of-type? mus 'note-event)
           (let* ((cuenote (ly:music-deep-copy mus))
                  (p (ly:music-property cuenote 'pitch)))
             (set! (ly:music-property cuenote 'pitch)
                   (ly:make-pitch (- offs 1) (ly:pitch-notename p) (ly:pitch-alteration p)))
             (set! (ly:music-property cuenote 'tweaks)
                   (assoc-set! (ly:music-property cuenote 'tweaks)
                              (cons 'NoteHead 'font-size)
                              -3))
             (set! (ly:music-property cuenote 'articulations) (list))
             (make-music 'EventChord
                         'elements (list mus cuenote))))
            
        ((music-is-of-type? mus 'sequential-music)
            (set! (ly:music-property mus 'elements)
                  (map (lambda (m) (octoHints offs m))
                       (ly:music-property mus 'elements)))

            mus)
        
        (else mus)))

% This is an alternative to octoHints that's maybe better. Notes have to be
% entered manually but they don't mess up stems, beams, and slurs.
\layout {
  \context {
    \name AwdHints
    \type Engraver_group
    \consists Note_heads_engraver
    \override NoteHead.font-size = -3
    \override NoteHead.style = #'harmonic-black
    \alias Voice
  }
  \inherit-acceptability AwdHints Voice
  \context { \Staff \accepts AwdHints }
}

altStaff =
#(define-music-function (b m) (string? ly:music?)
  "Renders a small staff for alternative parts. @var{m} is the music, @var{b}
  is the name of the staff to render it above. It would be cool to find that
  automatically but it's hard.

  This is not necessarily
the ideal way to do it... it might be better to define a staff at top-level
then use \\startStaff and \\stopStaff to bring it in and out.
"
  #{
    \new Staff \with {
      alignAboveContext = #b
      \omit Clef
      \omit TimeSignature
      \omit KeySignature
      fontSize = #-3
      \override StaffSymbol.staff-space = #(magstep -3)
    } { #m }
  #})

solo = ^\markup \smallCaps "Solo"

markit = #(define-event-function (m) (markup?)
  #{ -\markup \italic #m #})

% This is useful for stuff I'm actually going to print -- should prevent
% 3-digit measure numbers from getting cut off
awdPageSetup = \paper {
  #(set-paper-size "letter")
  left-margin = 0.5\in
}

awdTabletSetup = \paper {
  left-margin = 7\mm
  right-margin = 2\mm
  top-margin = 2\mm
  bottom-margin = 2\mm
}

boxSection = #(define-music-function (m) (markup?)
  #{ \sectionLabel \markup \box #m #})

% Function to put note names in markup. Maybe ideally it would use the
% chordRootNamer context property, but it's annoying to get a context in markup
% mode, and I don't necessarily need to be perfect about it :-P.
%
% Things this solves:
%  0. Just using \flat and \sharp gets the size and vertical alignment wrong
%  1. There's a Scheme function for this but no markup command
%  2. The Scheme function outputs a list markup, which gets rendered with a
%     space between the note name and accidental unless you squash that somehow
#(define-markup-command (note-name layout props note) (ly:pitch?)
  (interpret-markup layout props
    (markup #:override `(word-space . 0) (note-name->markup note #f))))
