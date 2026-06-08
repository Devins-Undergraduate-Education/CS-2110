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
binary_search_tree *init_tree(int (*comparator)(const void *, const void*), void (*destructor)(void *), void (*printer)(FILE *f, void *)) {
    // if param(s) is/are null, NULL
    if (comparator == NULL || destructor == NULL || printer == NULL) {
        return NULL;
    }

    // allocate space for, and create, tree
    binary_search_tree *tree = (binary_search_tree *)malloc(sizeof(binary_search_tree));
    if (tree == NULL) {
        return NULL; // malloc failed
    }

    // set root to null (since it's empty)
    tree->root = NULL;
    // set the comparator to the type
    tree->comparator = comparator;
    // set the destructor to the type
    tree->destructor = destructor;
    // set the printer to the type
    tree->printer = printer;
    // establish the tree as empty
    tree->num_nodes = 0;

    return tree;
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
    // if param(s) is/are null, NULL
    if (data == NULL) {
        return NULL;
    }

    // allocate space, and create, newNode
    Node *newNode = (Node *)malloc(sizeof(Node));
    if (newNode == NULL) {
        return NULL; // malloc failed
    }

    // set node's data to data
    newNode->data = data;
    // no left children
    newNode->left = NULL;
    // no right children
    newNode->right = NULL;

    return newNode;
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
    // if param(s) is/are null, ERROR
    if (tree == NULL || data == NULL) {
        return ERROR;
    }

    // create newNode and ensure non-failure
    Node *newNode = create_node(data);
    if (newNode == NULL) {
        return ERROR; // malloc failed
    }

    // set root to newNode if needed
    if (tree->root == NULL) {
        tree->root = newNode;
        tree->num_nodes++;
        return SUCCESS;
    }

    // set current node to root
    Node *currentNode = tree->root;
    Node *parentNode = NULL;

    // while not at a leaf
    while (currentNode != NULL) {
        parentNode = currentNode;

        // determine which way to go (l, r)
        int cmp = tree->comparator(data, currentNode->data);

        if (cmp < 0) {
            currentNode = currentNode->left; // traverse left
        } else if (cmp > 0) {
            currentNode = currentNode->right; // traverse right
        } else {
            free(newNode); // freeNewNode if it's already in the tree
            return ERROR; // ERROR if duplicate
        }
    }

    // leaf is now reached

    // determine to place l or r of currNode
    int cmp = tree->comparator(data, parentNode->data);

    if (cmp < 0) {
        parentNode->left = newNode; // place left
    } else {
        parentNode->right = newNode; // place right
    }

    tree->num_nodes++; // increment size

    return SUCCESS;
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
    // if param(s) is/are null, ERROR
    if (tree == NULL || data == NULL) {
        return ERROR; 
    }

    // assign a currNode that is the current node
    struct Node *currNode = tree->root;

    while (currNode != NULL) {
        // assign cmp value (see data_lib.c)
        int cmp = tree->comparator(data, currNode->data);

        if (cmp == 0) {
            return SUCCESS; // if the node is found
        } else if ( cmp < 0) {
            currNode = currNode->left; // traverse left
        } else if (cmp > 0) {
            currNode = currNode->right; // traverse right
        }
    }

    // data is not found
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
    // AAH! NOTHING!
    if (root == NULL) {
        return;
    }

    // add data to array
    arr[*index] = root->data;
    // increment size of index to be added to
    (*index)++;

    // recursively traverse left
    preorder_helper(root->left, arr, index);
    // recursively traverse right
    preorder_helper(root->right, arr, index);
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
    // if tree == null (WHY IS TREE NULL, THIS IS SO SAD)
   if (tree == NULL) {
        return NULL;
    }

    // create arr and allocate space for arr
    void **arr = (void **)malloc(tree->num_nodes * sizeof(void *));
    if (arr == NULL) {
        return NULL; // malloc failed
    }

    // let's start adding stuff!
    int index = 0;
    // RECURSION TIME
    preorder_helper(tree->root, arr, &index);

    return arr;
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
    // check if things are null because TAs are SO RUDE (especially gal)
    if (tree == NULL || data_removed == NULL) {
        return NULL;
    }

    // Get array of all values using preorder traversal
    void **dataArray = preorder_traversal(tree);

    if (dataArray == NULL) {
        free(dataArray);
        return NULL; // preorder_traversal failed (skill issue)
    }

    // Initialize a new BST (allocation stuffs happens in the method)
    binary_search_tree *newTree = init_tree(tree->comparator, tree->destructor, tree->printer);
    if (newTree == NULL) {
        free(dataArray); // frees the dataArray we dont use
        destroy_tree(newTree, 0);
        return NULL; // init_tree failed (skill issue)
    }

    // index of found node
    int foundDataRemoved = -1;

    // For each value in dataArray
    for (size_t i = 0; i < tree->num_nodes; ++i) {
        // If value == data_removed
        if (tree->comparator(dataArray[i], data_removed) == 0) {
            // if data matches data to be removed
            foundDataRemoved = i;
        } else {
            // if data is not found
            insert_node(newTree, dataArray[i]);
        }
    }

    // if the bad data is found
    if(foundDataRemoved >= 0) {
        // destroy the data, which effectively removes the pointer to the node
        tree->destructor(dataArray[foundDataRemoved]);
    } else {
        free(dataArray); // frees useless dataArray because bad data isn't even the tree
        destroy_tree(newTree, 0); // burn new tree since we are not returning it
        return NULL;
    }

    // Free the original tree
    destroy_tree(tree, 0); // Do not free data, as it's taken over by the new tree

    // Free the array obtained from preorder_traversal
    free(dataArray);

    return newTree;
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
    // WHY IS NODE NULL UGH BE BETTER
    if (node == NULL) {
        return;
    }

    // literally destroy the entire left side
    destroy_node(destructor, node->left, destroy_data);
    // literally destroy the entire right side
    destroy_node(destructor, node->right, destroy_data);

    // free data
    if (destroy_data) {
        destructor(node->data);
    }

    // *plays free bird* 
    free(node);
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
    // if trees are gone (RIP Lorax)
    if (tree == NULL) {
        return;
    }

    // BURN THE TREES. EVERY TREE MUST DUE
    destroy_node(tree->destructor, tree->root, destroy_data);

    // NO MORE ROOTS. NO MORE NUTRIENTS.
    tree->root = NULL;
    // NO CHILDREN. NO NODES. YOU DON'T EVEN EXIST.
    tree->num_nodes = 0;
    // IM FREEE. FREE FALLIN. (wrong song)
    free(tree);
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

    if (node->right) {
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