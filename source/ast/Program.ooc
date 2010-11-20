/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/ast/Program.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import structs/ArrayList
import Visitor, Node

/**
 * A decadence program
 */
Program: class {

    path: String

    // it's just a list of expressions, right?
    body := ArrayList<Node> new()

    init: func (=path) {}

    toString: func -> String {
        b := Buffer new()
        for(n in body) b append(n toString()). append('\n')
        b toString()
    }

}

