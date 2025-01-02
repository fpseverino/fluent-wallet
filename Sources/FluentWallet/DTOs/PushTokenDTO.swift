/// An object that contains the push notification token for a registered pass on a device.
///
/// See: [`PushToken`](https://developer.apple.com/documentation/walletpasses/pushtoken)
public struct PushTokenDTO: Codable {
    /// A push token the server uses to send update notifications for a registered pass to a device.
    public let pushToken: String

    public init(pushToken: String) {
        self.pushToken = pushToken
    }
}
