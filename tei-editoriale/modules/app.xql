xquery version "3.1";
module namespace app="http://localhost:8080/exist/apps/tei-editoriale/templates";
declare namespace tei="http://www.tei-c.org/ns/1.0";
import module namespace functx = "http://www.functx.com";
import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://localhost:8080/exist/apps/tei-editoriale/config" at "config.xqm";
import module namespace transform="http://exist-db.org/xquery/transform";



declare function app:generate-page($node as node(), $model as map(*), $page as xs:string) as element (div)
{
    element div {transform:transform(doc($config:app-root||"/index.xml"), doc($config:app-root||"/index.xsl"), ())}

};

declare function app:form($node as node(), $model as map(*))
{
    let $case := request:get-parameter("case", ())
    let $req := request:get-parameter("query", ())
    let $author := request:get-parameter("author", ())
    let $title := request:get-parameter("title", ())
    let $sd := request:get-parameter("start_date", ())
    let $fd := request:get-parameter("finish_date", ())
    let $sd1 := request:get-parameter("start_date1", ())
    let $fd1 := request:get-parameter("finish_date1", ())

    return element form
    {
        attribute action {},
            element div {attribute class {"search"},
            element br {},
            element br {},
            element label
            {
                attribute for {"query"},
                "Saisissez votre recherche"
            },
            element br {},
            element input {attribute name {"query"}, attribute value {$req}},
            element br {},
            element input
            {
                attribute type {"radio"},
                attribute id {"case-sensitive"},
                attribute name {"case"},
                attribute value {"sensetive"},
                if ($case = "sensetive") then attribute checked {"checked"} else ()
            },
            element label {attribute for {"case-sensitive"}, "Sensible à la casse"},
            element br {},
            element input
            {
                attribute type {"radio"},
                attribute id {"case-insensitive"},
                attribute name {"case"},
                attribute value {"insensetive"},
                if ($case = "sensetive") then ()  else attribute checked {"checked"}
            },
            element label {attribute for {"case-insensitive"}, "Insensible à la casse"},
            element br {},
            element button {"Lancer une recherche"}},
            element br {},
            element br {},
            element div{
                attribute class {"search"},
                element label {attribute for {"author"}, "Auteur"},
                element br {},
                element input
                {
                    attribute type {"checkbox"},
                    attribute id {"Flaubert"},
                    attribute name {"author"},
                    attribute value {"Gustave Flaubert"},
                    if (contains($author, "Gustave Flaubert") or not(exists($author))) then attribute checked {"checked"} else ()
                },
                element label {attribute for {"Flaubert"}, "Gustave Flaubert"},
                element br {},
                element input
                {
                    attribute type {"checkbox"},
                    attribute id {"Hesse"},
                    attribute name {"author"},
                    attribute value {"Hermann Hesse"},
                    if (contains($author, "Hermann Hesse") or not(exists($author))) then attribute checked {"checked"} else ()
                },
                element label {attribute for {"Hesse"}, "Hermann Hesse"},
                element br {},
                element input
                {
                    attribute type {"checkbox"},
                    attribute id {"Bronte"},
                    attribute name {"author"},
                    attribute value {"Emily Brontë"},
                    if (contains($author, "Emily Brontë") or not(exists($author))) then attribute checked {"checked"} else ()
                },
                element label {attribute for {"Bronte"}, "Emily Brontë"},
                element br {},
                element br {},
                element label {attribute for {"title"}, "Titre"},
                element br {},
                element input
                {
                    attribute type {"checkbox"},
                    attribute id {"Bovary"},
                    attribute name {"title"},
                    attribute value {"Madame Bovary"},
                    if (contains($title, "Madame Bovary") or not(exists($author))) then attribute checked {"checked"} else ()
                },
                element label {attribute for {"Bovary"}, "Madame Bovary"},
                element br {},
                element input
                {
                    attribute type {"checkbox"},
                    attribute id {"Siddhartha"},
                    attribute name {"title"},
                    attribute value {"Siddhartha"},
                    if (contains($title, "Siddhartha") or not(exists($author))) then attribute checked {"checked"} else ()
                },
                element label {attribute for {"Siddhartha"}, "Siddhartha"},
                element br {},
                element input
                {
                    attribute type {"checkbox"},
                    attribute id {"WH"},
                    attribute name {"title"},
                    attribute value {"Wuthering Heights"},
                    if (contains($title, "Wuthering Heights") or not(exists($author))) then attribute checked {"checked"} else ()
                },
                element label {attribute for {"WH"}, "Wuthering Heights"}},
            element div {attribute class {"search"},    
            element label {attribute for {"start"}, "Écrit après l'année"},
                element br {},
                element input
                {
                    attribute type {"number"},
                    attribute id {"start"},
                    attribute name {"start_date"},
                    attribute min {"1800"},
                    attribute max {"2021"},
                    if (exists($sd)) then attribute value {$sd} else attribute value {"1800"}
                },
                element br {},
                element br {},
                element label {attribute for {"finish"}, "Écrit avant l'année"},
                element br {},
                element input
                {
                    attribute type {"number"},
                    attribute id {"finish"},
                    attribute name {"finish_date"},
                    attribute min {"1800"},
                    attribute max {"2021"},
                    if (exists($fd)) then attribute value {$fd} else attribute value {"2021"}
                },
                element br {},
                element br {},
                element label {attribute for {"start1"}, "Publié après la date"},
                element br {},
                element input
                {
                    attribute type {"date"},
                    attribute id {"start1"},
                    attribute name {"start_date1"},
                    attribute min {"1800-01-01"},
                    attribute max {"2021-01-01"},
                    if (exists($sd1)) then attribute value {$sd1} else attribute value {"1800-01-01"}
                },
                element br {},
                element br {},
                element label {attribute for {"finish1"}, "Publié avant la date"},
                element br {},
                element input
                {
                    attribute type {"date"},
                    attribute id {"finish1"},
                    attribute name {"finish_date1"},
                    attribute min {"1800-01-01"},
                    attribute max {"2021-01-01"},
                    if (exists($fd1)) then attribute value {$fd1} else attribute value {"2021-01-01"}
                },
                element br {},
                element br {}
            }
        
    }
};


declare function app:normalize($p as node(), $keepformating as xs:boolean)
{
    if ($keepformating) then transform:transform($p, doc($config:app-root||"/templates/change_format.xsl"), ())
    else transform:transform($p, doc($config:app-root||"/templates/remove_format.xsl"), ())
    
};


declare function app:find($node as node(), $model as map(*))
{
    let $case := request:get-parameter("case", ())
    let $req := if ($case = "insensetive") then lower-case(request:get-parameter("query", ())) else request:get-parameter("query", ())
    let $l := string-length($req)
    let $author := request:get-parameter("author", ())
    let $title := request:get-parameter("title", ())
    let $sd := request:get-parameter("start_date", ())
    let $fd := request:get-parameter("finish_date", ())
    let $sd1 := request:get-parameter("start_date1", ())
    let $fd1 := request:get-parameter("finish_date1", ())
        for $modified_book in collection($config:data-root)
        let $book := app:normalize($modified_book, false())
        let $book_author := $book/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author/text()
        let $book_title := $book/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/text()
        let $book_date := string-join(reverse(tokenize($book/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date, "/")), "-")
        return if ($author = $book_author[../../../tei:publicationStmt/tei:date[@when > $sd and @when < $fd]] and $title = $book_title and $book_date > $sd1 and $book_date < $fd) then
            if ($req) then
            let $text := if ($case = "insensetive") then $book/tei:text/tei:body/tei:div/tei:div/tei:p[contains(lower-case(text()), $req)] else $book/tei:text/tei:body/tei:div/tei:div/tei:p[contains(text(), $req)]
            for $t in $text/text()
            let $starts := insert-before(if ($case = "insensetive") then functx:index-of-string(lower-case($t), $req) else functx:index-of-string($t, $req), 9999999999999, (9999999999999))
            let $ends := insert-before((for $start in $starts where $start != 9999999999999 return $start+$l), 1, 1)
            return
                (element h3{$book_title},
                element h4 {concat("par ", $book_author)},
                element p
                {for $start at $i in $starts
                    return if ($start != 9999999999999)
                        then (substring($t, $ends[$i], $start - $ends[$i]), <mark>{substring($t, $start, $l)}</mark>)
                        else substring($t, $ends[$i], $start)})
    else(element h3{$book_title}, element h4 {concat("par ", $book_author)})
    else ()
};


declare function app:generate($node as node(), $model as map(*)) as element(div){
    element div
    {
    let $shown := request:get-parameter("shown", ())
    for $modified_book in collection($config:data-root)
        let $book := app:normalize($modified_book, true())
        let $title := $book/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/text()
        let $author := $book/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author/text()
        let $link := substring($book/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p[contains(text(), "Disponible à l'adresse suivante")]/text(), 32)
        let $text := $book/tei:text/tei:body
        return element p
        {
            element a
            {
                attribute href {concat("http://localhost:8080/exist/apps/tei-editoriale/visual.html?", app:change-params($title))},
                element h2 {$title}
            },
            element br {},
            element div
            {
                if (replace($title, " ", "-") = $shown) then () else attribute style {"display:none"},
                
                (element h3 {concat("par ", $author)},
                $text/tei:p,
                for $part in $text/tei:div
                    let $part_head := $part/tei:head
                    return
                    (if ($part_head) then
                        element a
                        {
                            attribute href {concat("http://localhost:8080/exist/apps/tei-editoriale/visual.html?", app:change-params($part_head))},
                            element h4 {$part_head}
                            
                        }
                        else (),
                        element div
                        {
                            if (replace(replace($part_head, " ", "-"), "È", "_") = $shown or not($part_head)) then () else attribute style {"display:none"},
                            ($part/tei:p,
                            for $chapter in $part/tei:div
                                let $chapter_head := $chapter/tei:head
                                return
                                (
                                    element a
                                    {
                                        attribute href {concat("http://localhost:8080/exist/apps/tei-editoriale/visual.html?", app:change-params($chapter_head))},
                                        element h5 {$chapter_head}
                                    },
                                    element div
                                    {
                                        if (replace($chapter_head, " ", "-") = $shown) then () else attribute style {"display:none"},
                                        for $p in $chapter/tei:p return $p
                                    }
                                )
                            )
                        }
                    ),
                    element i
                    {
                        "Disponible à l'adresse suivante ",
                        element a
                        {
                            attribute href {$link},
                            $link
                        }
                    }
                )
            }
        }
        
    }
};

declare function app:change-params ($element as xs:string)
{
    let $q := request:get-query-string()
    let $el := replace(replace($element, " ", "-"), "È", "_")
    return
        if ($el = tokenize(replace($q, "&amp;", ""), "shown="))
        then
            let $res := replace(concat($q, "&amp;"), concat("shown=", $el, "&amp;"), "")
            return substring($res, 1, string-length($res)-1)
        else
            if ($q)
            then concat($q, "&amp;shown=", $el)
            else concat($q, "shown=", $el)
    
};