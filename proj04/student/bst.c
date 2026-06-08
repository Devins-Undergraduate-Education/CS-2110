#include "bst.h"

/**
 * Allocates and initializes the binary search tree (BST) with the passed in comparator, destructor, and printer functions.
 *
 * Assume the tree starts without any nodes when setting the root and num_nodes.
 *
 * @param comparator the comparator function for the BST
 * @param destructor the destructor function for the BST
 * @param printer the printer function for the BST
 * @return a pointer to the newly constructed binary_search_tree struct, NULL if malloc fails
 */
binary_search_tree *init_tree(int (*comparator)(const void *, const void*),
                              void (*destructor)(void *),
                              void (*printer)(FILE *f, void *)) {
    //TODO
    UNUSED(comparator);
    UNUSED(destructor);
    UNUSED(printer);
    return NULL;
}

/**
 * Allocates and initializes a new Node with the passed in data, and return a pointer to it.
 *
 * Make sure to set the left and right pointers of the Node to NULL.
 *
 * @param data the data to be inserted in the node
 * @return a pointer to the newly constructed Node struct or NULL if data is NULL/malloc fails
 */
Node *create_node(void *data) {
    //TODO
    UNUSED(data);
    return NULL;
}

/**
 * Creates a new node given the passed in data and correctly inserts it into the passed in BST
 *
 * Refer to the Binary Search Tree Implementation in the PDF for the correct way to insert nodes into BSTs.
 *
 * The create_node function should be called in this function.
 *
 * @param tree the BST that the new Node should be inserted into
 * @param data the data to be inserted in a new Node
 * @return SUCCESS if the node is successfully added to the tree, otherwise ERROR if
 * the parameters are NULL, malloc fails, or the data is already in the BST
 */
int insert_node(binary_search_tree *tree, void *data) {
    //TODO
    UNUSED(tree);
    UNUSED(data);
    return ERROR;
}


/**
 * Checks to see if a Node with the given data is in the BST.
 *
 * @param tree the BST that should be searched
 * @param data the data that is being looked for
 * @return SUCCESS if the data is found, ERROR if
 * the parameters are NULL or the data is not found
 */
int contains(binary_search_tree *tree, void *data) {
    //TODO
    UNUSED(tree);
    UNUSED(data);
    return ERROR;
}



/**
 * Recursive helper method for preorder_traversal().
 *
 * Note: This method is not directly tested. You will only be tested on your implementation of preorder_traversal().
 * However, you may find it helpful to use this function in your implementation of preorder_traversal().
 *
 * @param root the root node of the current subtree being traversed
 * @param arr the array of data that has been traversed
 * @param index the index at which to add the next data
 */
void preorder_helper(Node* root, void** arr, int* index) {
    //TODO
    UNUSED(root);
    UNUSED(arr);
    UNUSED(index);
}

/**
 * Allocate and initialize an array of pointers that point to the data from the given tree in preorder traversal order.
 *
 * Refer to the Introduction in the PDF for a discussion on preorder tree traversal.
 *
 * @param tree the BST to be traversed
 * @return a newly created array of pointers that point to the data in preorder traversal order,
 * NULL if the tree is NULL or malloc fails
 */
void** preorder_traversal(binary_search_tree *tree) {
    //TODO
    UNUSED(tree);
    return NULL;
}

/**
 * Create a new tree that is a duplicate of the passed in tree excluding the node that has data that matches the data passed in.
 *
 * Make sure to completely free the previous tree using the destroy_tree function and data that matches data_removed.
 * Note: You should free the original tree (but not its data!). If you need to return NULL, ensure that the original tree is unchanged.
 *
 * @param tree the BST to duplicate without the data_removed
 * @param data_removed the data that should not be included in the duplicated tree
 * @return a pointer to the newly constructed binary_search_tree struct without the data_removed,
 * NULL if the inputs are NULL or malloc fails
 */
binary_search_tree *duplicate_without(binary_search_tree *tree, void *data_removed) {
    //TODO
    UNUSED(tree);
    UNUSED(data_removed);
    return NULL;
}

/**
 * Free the passed in node and free all nodes that are direct and indirect descendants of the node.
 *
 * Only free the data associated with each node if destroy_data is 1. Otherwise, do NOT free the data of the freed nodes.
 * 
 * Note: This method is not directly tested. You will only be tested on your implementation of destroy_tree().
 * However, you may find it helpful to use this function in your implementation of destroy_tree().
 *
 * @param destructor the destructor to free the data
 * @param node the node that should be freed along with all the nodes below it
 * @param destroy_data if 1, free the data with the destructor for every node you free, otherwise do not free the data
 */
void destroy_node(void (*destructor)(void *), Node *node, int destroy_data) {
    //TODO
    UNUSED(destructor);
    UNUSED(node);
    UNUSED(destroy_data);
}

/**
 * Free the entire tree including all of the nodes.
 *
 * Only free the data if destroy_data is 1. Otherwise, do NOT free the data.
 *
 * The destroy_node function should be called in this function.
 *
 * @param destructor the tree to be destroyed
 * @param destroy_data if 1, free all the data, otherwise do not free the data
 */
void destroy_tree(binary_search_tree *tree, int destroy_data) {
    //TODO
    UNUSED(tree);
    UNUSED(destroy_data);
}


/**
 * DO NOT EDIT - Already implemented for students
 *
 * Recursive helper for print_tree() function
 */
void print_helper(FILE *f, binary_search_tree *tree, Node *node, int level) {
    if (node->left) {
        for (int i = 0; i < level; i++) {
            fprintf(f, "    ");
        }
        fprintf(f, "L: ");
        tree->printer(f, node->left->data);
        fprintf(f, "\n");
        print_helper(f, tree, node->left, level+1);
    }

    if(node->right) {
        for (int i = 0; i < level; i++) {
            fprintf(f, "    ");
        }
        fprintf(f, "R: ");
        tree->printer(f, node->right->data);
        fprintf(f, "\n");
        print_helper(f, tree, node->right, level+1);
    }

}

/**
 * DO NOT EDIT - Already implemented for students
 *
 * Prints the BST.
 */
void print_tree(FILE *f, binary_search_tree *tree) {
    Node *root = tree->root;
    if (!root) {
        return;
    }
    fprintf(f, "Root: ");
    tree->printer(f, root->data);
    fprintf(f, "\n");
    print_helper(f, tree, root, 1);
}
