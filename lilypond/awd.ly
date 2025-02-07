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
#(define-music-function (m) (ly:music?)
  "Renders a small staff for alternative parts. This is not necessarily
the ideal way to do it... it might be better to define a staff at top-level
then use \\startStaff and \\stopStaff to bring it in and out.
"
  #{
    \new Staff \with { fontSize = #-3 \override StaffSymbol.staff-space = #(magstep -3)} { \once {\omit Staff.TimeSignature \omit Staff.Clef \omit Staff.KeySignature} #m }
  #})
