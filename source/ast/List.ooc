/*
 * @author Nick Markwell
 */

import Node, Visitor

/**
 * Represents access to a variable
 */
List: class extends Node {

    inner: String

    init: func (=inner) {}

    toString: func -> String {
        inner
    }

    accept: func (v: Visitor) {
        v visitList(this)
    }

}

