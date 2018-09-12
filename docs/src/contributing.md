## Contributing

If you have a model or an algorithm which in your opinion should be included in
the package, please open an issue at GitHub. After discussing the issue and the
proposed changes, we will be happy to include your code in the main tree.

Please do not send pull request before an issue!


## Bugs

In the case, you noticed some bugs, please start with an issue with a minimal
working example reproducing it. If *Exception* is thrown, please provide an
exception message as well.  If no *Exception* is thrown, but the result is
invalid, please provide the correct answer in the issue message.

Please add the example reproducing the problem as a test in the pull request.

## Improvements

If you can provide a code, which works faster than already existing, please
check its efficiency for various input data. In particular, check various
*dynamics* and *graphs*. Typically checked graphs are `PathGraph` and `CompleteGraph`.

The efficiency of the quantum walk model evolution may depend strongly on the graph
properties, including order and sparsity. If your implementation works better only
on some collection, please provide it as a separate model, possible as a subtype of
an already existing model if possible. Note we are interested in the implementation
which works well for *many* parameters, not only for fixed graphs.

We welcome any ideas concerning the readability and logic of the code as well.

## Development guidelines
* Post an issue.
* Wait until the discussion ends.
* Check the name convention from already existing model.
* Try to make your code as general as possible, for example:
  * Check if the general functions as `measure` or `evolve` are defined for
  abstract supertype (if you provide such).
  * Check the requirements for model/dynamics. If possible, extend them.
* Create assertions on argument types and other requirements.
* Include necessary references.
* Write tests.
