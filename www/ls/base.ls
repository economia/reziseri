new Tooltip!watchElements!
ig.containers.base.innerHTML = ig.data.reziseri
container = d3.select ig.containers.base
svg = container.select \svg
zoomBase = svg.select \#zoomBase
zoomContent = svg.select \#zoomContent
overlay = svg.select \#overlay
overlay.append \rect
    ..attr \width 5176
    ..attr \height 5775
    ..attr \x -1565
    ..attr \y -1979

zoom = ->
    zoomContent.attr \transform "translate(#{d3.event.translate})scale(#{d3.event.scale})"
class Person
    (@name, @element) ->
        @paths = []
        @neighbors = []
class Neighbor
    (@person, @path) ->
zoomBehavior = d3.behavior.zoom!scaleExtent [1, 4] .on \zoom zoom
zoomBase.call zoomBehavior
persons = []
names = {}
people = zoomContent.selectAll \circle
    ..each ->
        name = @getAttribute \data-name
        person = new Person name, @
        names[name] = person
        persons.push person

connections = zoomContent.selectAll \path
    ..each ->
        path = @getAttribute \data-name
        neighbors = []
        for {name}:person in persons
            if -1 !== path.indexOf name
                len = neighbors.push new Neighbor person, @
                break if len == 2
        return unless neighbors.length == 2
        neighbors.0.person.neighbors.push neighbors.1
        neighbors.1.person.neighbors.push neighbors.0

for person in persons
    person.element.setAttribute \data-tooltip escape "<b>#{person.name}</b><br />Spolupracoval s #{person.neighbors.length} lidmi"

people
    ..on \mouseover ->
        @setAttribute \data-hover \true
        name = @getAttribute \data-name
        for {person, path} in names[name].neighbors
            person.element.setAttribute \data-hover \true
            path.setAttribute \data-hover \true

    ..on \mouseout ->
        people.attr \data-hover ""
        connections.attr \data-hover ""

    ..on \click ->
        wasActive = "true" == @getAttribute \data-click
        people.attr \data-click ""
        connections.attr \data-click ""
        return if wasActive
        @setAttribute \data-click \true
        name = @getAttribute \data-name
        for {person, path} in names[name].neighbors
            person.element.setAttribute \data-click \true
            path.setAttribute \data-click \true
