Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``drone``
^^^^^^^^^
*Meta-state*.

This installs the drone containers,
manages their configuration and starts their services.


``drone.package``
^^^^^^^^^^^^^^^^^
Installs the drone containers only.
This includes creating systemd service units.


``drone.config``
^^^^^^^^^^^^^^^^
Manages the configuration of the drone containers.
Has a dependency on `drone.package`_.


``drone.service``
^^^^^^^^^^^^^^^^^
Starts the drone container services
and enables them at boot time.
Has a dependency on `drone.config`_.


``drone.clean``
^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``drone`` meta-state
in reverse order, i.e. stops the drone services,
removes their configuration and then removes their containers.


``drone.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the drone containers
and the corresponding user account and service units.
Has a depency on `drone.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``drone.config.clean``
^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the drone containers
and has a dependency on `drone.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``drone.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Stops the drone container services
and disables them at boot time.


