Radium.NotificationView = Radium.View.extend
  layoutName: 'notification'

Radium.NotificationsAssignTodoView = Radium.NotificationView.extend()
Radium.NotificationsAssignDealView = Radium.NotificationView.extend()
Radium.NotificationsAssignContactView = Radium.NotificationView.extend()
Radium.NotificationsLeadEmailView = Radium.NotificationView.extend()
Radium.NotificationsNewUserView = Radium.NotificationView.extend()
Radium.NotificationsNewEmailView = Radium.NotificationView.extend()
Radium.NotificationsScheduledEmailView = Radium.NotificationView.extend()
Radium.NotificationsReplyEmailView = Radium.NotificationView.extend()
Radium.NotificationsNoReplyEmailView = Radium.NotificationView.extend()
Radium.NotificationsNotRepliedEmailView = Radium.NotificationView.extend()
Radium.NotificationsNewInvitationView = Radium.NotificationView.extend()
Radium.NotificationsNewContactImportJobView = Radium.NotificationView.extend()
Radium.NotificationsNewAccountView = Radium.NotificationView.extend()
Radium.NotificationsPrimaryContactDeletedDealView = Radium.NotificationView.extend()
Radium.NotificationsOpenContactView = Radium.NotificationView.extend()
Radium.NotificationsClickContactView = Radium.NotificationView.extend()
Radium.NotificationsUnsubscribeExternalView = Radium.NotificationView.extend()
Radium.NotificationsUnsubscribeExternalView = Radium.NotificationView.extend()
Radium.NotificationsExportFinishedContactView = Radium.NotificationView.extend
  expiryDate: Ember.computed 'controller.time', ->
    @get('controller.time').advance(hour: 1)
