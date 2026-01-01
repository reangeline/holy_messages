# 🎨 App Widget Setup Guide (iOS & Android)

## Visão Geral

App Widgets são pequenas janelas na tela inicial que mostram informações sem precisar abrir o app. Para o **Holy Messages**, vamos criar um widget que mostra o versículo do dia.

## Compatibilidade

| Sistema | Suporte | Biblioteca |
|---------|---------|-----------|
| **Android** | ✅ Nativo | AppWidgetHostView |
| **iOS** | ✅ WidgetKit (iOS 14+) | WidgetKit Framework |
| **Flutter** | Parcial | home_widget 0.5.0+ |

---

## Part 1: Adicionar Dependência

### 1.1 Atualizar pubspec.yaml

```yaml
dependencies:
  home_widget: ^0.5.0
  flutter:
    sdk: flutter
```

### 1.2 Instalar

```bash
flutter pub get
```

---

## Part 2: Configurar Android

### 2.1 Criar Widget Layout

Crie `android/app/src/main/res/layout/app_widget.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_background"
    android:gravity="center"
    android:orientation="vertical"
    android:padding="16dp">

    <TextView
        android:id="@+id/verse_text"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="18sp"
        android:textColor="#1E293B"
        android:textStyle="italic"
        android:text="Carregando versículo..." />

    <TextView
        android:id="@+id/verse_reference"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="14sp"
        android:textColor="#64748B"
        android:layout_marginTop="8dp"
        android:text="Holy Messages" />

</LinearLayout>
```

### 2.2 Criar Background do Widget

Crie `android/app/src/main/res/drawable/widget_background.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="#FEF3C7" />
    <corners android:radius="16dp" />
    <stroke android:width="2dp" android:color="#FCD34D" />
</shape>
```

### 2.3 Criar AppWidget Provider

Crie `android/app/src/main/kotlin/com/example/holy_messages/AppWidget.kt`:

```kotlin
package com.example.holy_messages

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.os.Build

class AppWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        // Obter dados do SharedPreferences
        val sharedPref = context.getSharedPreferences("flutter_shared", Context.MODE_PRIVATE)
        val verseText = sharedPref.getString("daily_verse", "Carregando versículo...") ?: "Carregando versículo..."
        val verseRef = sharedPref.getString("daily_verse_ref", "Holy Messages") ?: "Holy Messages"

        // Criar RemoteViews
        val views = RemoteViews(context.packageName, R.layout.app_widget)
        views.setTextViewText(R.id.verse_text, verseText)
        views.setTextViewText(R.id.verse_reference, verseRef)

        // Intent para abrir app ao clicar no widget
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        } else {
            PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        }
        views.setOnClickPendingIntent(R.id.app_widget, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
```

### 2.4 Registrar no AndroidManifest.xml

Adicione em `android/app/src/main/AndroidManifest.xml`:

```xml
<receiver
    android:name=".AppWidget"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/app_widget_info" />
</receiver>
```

### 2.5 Criar Metadados do Widget

Crie `android/app/src/main/res/xml/app_widget_info.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="250dp"
    android:minHeight="200dp"
    android:updatePeriodMillis="3600000"
    android:previewImage="@drawable/widget_preview"
    android:initialLayout="@layout/app_widget"
    android:widgetCategory="home_screen"
    android:resizeMode="horizontal|vertical" />
```

---

## Part 3: Configurar iOS

### 3.1 Criar Widget Extension (Xcode)

1. Abra `ios/Runner.xcworkspace` no Xcode
2. File → New → Target
3. Escolha **Widget Extension**
4. Nome: `HolyMessagesWidget`
5. Finish

### 3.2 Criar Widget View

Em `ios/HolyMessagesWidget/HolyMessagesWidget.swift`:

```swift
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DailyEntry {
        DailyEntry(
            date: Date(),
            verse: "Carregando versículo...",
            reference: "Holy Messages"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyEntry) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: "group.com.holy.messages")
        let verse = sharedDefaults?.string(forKey: "daily_verse") ?? "Carregando..."
        let reference = sharedDefaults?.string(forKey: "daily_verse_ref") ?? "Holy Messages"
        
        let entry = DailyEntry(date: Date(), verse: verse, reference: reference)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyEntry>) -> ()) {
        var entries: [DailyEntry] = []
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.holy.messages")
        let verse = sharedDefaults?.string(forKey: "daily_verse") ?? "Carregando..."
        let reference = sharedDefaults?.string(forKey: "daily_verse_ref") ?? "Holy Messages"

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DailyEntry(date: entryDate, verse: verse, reference: reference)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DailyEntry: TimelineEntry {
    let date: Date
    let verse: String
    let reference: String
}

struct HolyMessagesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.99, green: 0.95, blue: 0.78),
                    Color.white,
                    Color(red: 0.99, green: 0.84, blue: 0.66)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 12) {
                Text(entry.verse)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .italic()
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
                    .lineLimit(4)
                
                Divider()
                
                Text(entry.reference)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
            }
            .padding(16)
        }
        .cornerRadius(12)
    }
}

@main
struct HolyMessagesWidget: Widget {
    let kind: String = "HolyMessagesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HolyMessagesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Holy Messages")
        .description("Versículo do dia")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    HolyMessagesWidget()
} timeline: {
    DailyEntry(
        date: .now,
        verse: "Por Deus amou o mundo de tal maneira que deu seu Filho unigênito",
        reference: "João 3:16"
    )
}
```

### 3.3 Configurar App Groups

1. Abra `ios/Runner.xcworkspace`
2. Selecione **Runner** → **Signing & Capabilities**
3. Clique **+ Capability**
4. Adicione **App Groups**
5. Adicione grupo: `group.com.holy.messages`
6. Repita para o target **HolyMessagesWidget**

---

## Part 4: Atualizar Dados do Widget em Flutter

### 4.1 Criar Serviço para Atualizar Widget

Crie `lib/features/bible/services/widget_service.dart`:

```dart
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetService {
  static Future<void> updateDailyVerseWidget({
    required String verse,
    required String reference,
  }) async {
    try {
      // Salvar em SharedPreferences para acesso nativo
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('daily_verse', verse);
      await prefs.setString('daily_verse_ref', reference);

      // Atualizar widget (se disponível)
      await HomeWidget.updateWidget(
        androidName: 'AppWidget',
        iosName: 'HolyMessagesWidget',
        qualifiedAndroidName: 'com.example.holy_messages.AppWidget',
      );

      print('✅ Widget atualizado: $reference');
    } catch (e) {
      print('❌ Erro ao atualizar widget: $e');
    }
  }
}
```

### 4.2 Atualizar DailyVerseController

Adicione ao `lib/features/bible/state/daily_verse_controller.dart`:

```dart
import '../services/widget_service.dart';

// No método que carrega o versículo do dia, adicione:
Future<void> updateWidget() async {
  final verse = state?.verse ?? '';
  final reference = state?.reference ?? '';
  
  if (verse.isNotEmpty && reference.isNotEmpty) {
    await WidgetService.updateDailyVerseWidget(
      verse: verse,
      reference: reference,
    );
  }
}
```

### 4.3 Adicionar pubspec.yaml

```yaml
dependencies:
  shared_preferences: ^2.2.0
  home_widget: ^0.5.0
```

---

## Part 5: Testar

### Android
```bash
flutter run
# Clique e segure na tela inicial
# Adicione widget → Holy Messages Widget
```

### iOS
```bash
flutter run
# Deslize para esquerda na tela inicial (Edit)
# Clique em + → Holy Messages → Add Widget
```

---

## Checklist

- [ ] Adicionar home_widget ao pubspec.yaml
- [ ] Criar layout do widget Android
- [ ] Criar AppWidget.kt
- [ ] Registrar em AndroidManifest.xml
- [ ] Criar Widget Extension iOS
- [ ] Configurar App Groups iOS
- [ ] Criar WidgetService em Flutter
- [ ] Testar em Android
- [ ] Testar em iOS

---

## Referências

- [home_widget pub.dev](https://pub.dev/packages/home_widget)
- [Android App Widgets](https://developer.android.com/develop/ui/views/appwidgets)
- [iOS WidgetKit](https://developer.apple.com/widgetkit/)
