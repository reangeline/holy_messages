import Flutter
import UIKit
import UserNotifications

// NOTA: Firebase desabilitado temporariamente
// Para habilitar: siga instruções em FIREBASE_SETUP.md

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("🚀 Iniciando app com notificações locais")
    
    // Configurar notificações locais
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      // Solicitar permissões
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if granted {
          print("✅ Permissões de notificação concedidas")
        } else if let error = error {
          print("❌ Erro ao solicitar permissões: \(error.localizedDescription)")
        }
      }
    }
    
    // Registrar para notificações remotas (necessário para APNs)
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handler para quando recebe o APNs token
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("📱 APNs token recebido")
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("📱 Token: \(token)")
  }
  
  // Handler para erros no registro
  override func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("⚠️ Erro ao registrar para notificações remotas: \(error.localizedDescription)")
    print("💡 Notificações locais continuarão funcionando normalmente")
  }
  
  // Handler quando notificação chega com app em foreground
  @available(iOS 10.0, *)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("📬 Notificação recebida em foreground")
    
    // Mostrar banner, som e badge
    if #available(iOS 14.0, *) {
      completionHandler([[.banner, .sound, .badge]])
    } else {
      completionHandler([[.alert, .sound, .badge]])
    }
  }
  
  // Handler quando usuário toca na notificação
  @available(iOS 10.0, *)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    print("👆 Usuário tocou na notificação")
    
    let userInfo = response.notification.request.content.userInfo
    print("Dados: \(userInfo)")
    
    completionHandler()
  }
}
