abstract class AppStates {}

class AppInitialState extends AppStates {}

class LoadingState extends AppStates {}

class CreateUserSucceedState extends AppStates {}

class CreateUserFailedState extends AppStates {}

class SignInUserSucceedState extends AppStates {}

class SignInUserFailedState extends AppStates {}

class StoreUserInFireStoreSucceedState extends AppStates {}

class StoreUserInFireStoreFailedState extends AppStates {}

class LoginChangePasswordVisibilityState extends AppStates {}

class ChangeIsManager extends AppStates {}

class ChangeSelectedUserState extends AppStates {}

class UpdateTaskSucceedState extends AppStates {}

class UpdateTaskFailedState extends AppStates {}

class GetAllEmployeesSucceedState extends AppStates {}

class GetAllEmployeesFailedState extends AppStates {}

class GetAllTasksOfEmployeesSucceedState extends AppStates {}

class GetAllTasksOfEmployeesFailedState extends AppStates {}

class GetAllTasksSucceedState extends AppStates {}

class GetAllTasksFailedState extends AppStates {}

class CreateTaskSucceedState extends AppStates {}

class CreateTaskFailedState extends AppStates {}

class SendNotificationsSucceedState extends AppStates {}

class SendNotificationsFailedState extends AppStates {}

class UpdateOSUserIDSucceedState extends AppStates {}

class UpdateOSUserIDFailedState extends AppStates {}

class GetSpacificUserSucceedState extends AppStates {}

class GetSpacificUserFailedState extends AppStates {}

class DeleteTaskSucceedState extends AppStates {}

class DeleteTaskFailedState extends AppStates {}
