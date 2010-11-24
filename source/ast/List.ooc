/*
 * @author Nick Markwell
 */

import Node, Visitor
import structs/ArrayList

/**
 * Represents access to a variable
 */
List: class extends Node {

    parent : List = null
    body := ArrayList<Node> new()

    init: func ~withParent (=parent) { }
    init: func { }

    add: func(n: Node) {
        body add(n)
    }

    toString: func -> String {
        if(body size > 0) {
            b := Buffer new()
            b append("(")
            body size times(|i|
                b append(body[i] toString())
                if(i < (body size - 1)) b append(' ')
            )
            b append(")")
            b toString()
        } else {
            "(nil)"
        }
    }

    accept: func (v: Visitor) {
        v visitList(this)
    }

}

