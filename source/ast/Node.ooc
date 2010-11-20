/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/ast/Node.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import Visitor

/**
 * An AST node
 */
Node: abstract class {

    // Gives a string representation of this node
    toString: abstract func -> String

    accept: abstract func (v: Visitor)

}

