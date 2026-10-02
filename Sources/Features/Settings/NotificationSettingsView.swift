import SwiftUI
import UserNotifications

/// The editable list of daily-reading times, apart from the UI so the rules
/// (at most 3, at least 1, no duplicates) can be tested. Each row keeps a
/// stable id while it is edited and stays where it is: keyed by its value, a
/// row was rebuilt (closing the picker) and could jump or merge into another
/// time on every tick of the wheel.
struct ReadingReminderTimes: Equatable {
    struct Slot: Identifiable, Equatable {
        let id: UUID
        var minutes: Int
    }

    static let maxCount = 3
    static let newTimeDefault = 12 * 60

    private(set) var slots: [Slot]

    init(_ minutes: [Int]) {
        let clean = Array(Set(minutes.map { min(max($0, 0), 24 * 60 - 1) })).sorted()
        slots = (clean.isEmpty ? ReadingReminderScheduler.defaultMinutes : Array(clean.prefix(Self.maxCount)))
            .map { Slot(id: UUID(), minutes: $0) }
    }

    var minutes: [Int] { slots.map(\.minutes) }
    var canAdd: Bool { slots.count < Self.maxCount }
    var canRemove: Bool { slots.count > 1 }

    /// Adds the first free time starting at midday, stepping an hour.
    mutating func add() {
        guard canAdd else { return }
        var candidate = Self.newTimeDefault
        while minutes.contains(candidate) { candidate = (candidate + 60) % (24 * 60) }
        slots.append(Slot(id: UUID(), minutes: candidate))
    }

    mutating func remove(_ id: UUID) {
        guard canRemove else { return }
        slots.removeAll { $0.id == id }
    }

    /// Changes one time. A value another row already has is refused, so a
    /// wheel passing over it never merges the two rows.
    @discardableResult
    mutating func replace(_ id: UUID, with new: Int) -> Bool {
        guard let index = slots.firstIndex(where: { $0.id == id }),
              !slots.contains(where: { $0.id != id && $0.minutes == new }) else { return false }
        slots[index].minutes = new
        return true
    }
}

struct NotificationSettingsView: View {
    @State private var times = ReadingReminderTimes(ReadingReminderScheduler.times)
    /// Bumped when a time is refused, so the picker snaps back to the kept one.
    @State private var refusals = 0
    @State private var status: UNAuthorizationStatus = .authorized
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(L.string("Each notification brings the word of the day.", table: "SettingsDetail"))
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.68))
                if status != .authorized { permissionCard }
                VStack(alignment: .leading, spacing: 8) {
                    Eyebrow(text: L.string("Reading times", table: "SettingsDetail"))
                    card {
                        ForEach(times.slots) { slot in
                            if slot.id != times.slots.first?.id { Divider().opacity(0.5) }
                            timeRow(slot)
                        }
                        if times.canAdd {
                            Divider().opacity(0.5)
                            Button {
                                times.add()
                                save()
                            } label: {
                                Label(L.string("Add a time", table: "SettingsDetail"), systemImage: "plus")
                                    .font(MissaleFont.body(17))
                                    .foregroundStyle(Palette.wine)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                    .contentShape(Rectangle())
                            }
                            .accessibilityIdentifier("addReadingTime")
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 30)
        }
        .background(MockLiturgical.today.color.pageBackground.ignoresSafeArea())
        .navigationTitle(L.string("Notifications", table: "SettingsDetail"))
        .navigationBarTitleDisplayMode(.inline)
        .task(id: scenePhase) { await loadStatus() }
    }

    private func timeRow(_ slot: ReadingReminderTimes.Slot) -> some View {
        HStack {
            DatePicker("", selection: binding(for: slot), displayedComponents: .hourAndMinute)
                .labelsHidden()
                .id("\(slot.id)-\(refusals)")
                .environment(\.locale, AppLanguagePreference.resolveCurrent().locale)
            Spacer(minLength: 8)
            if times.canRemove {
                Button {
                    times.remove(slot.id)
                    save()
                } label: {
                    Image(systemName: "minus.circle")
                        .foregroundStyle(Palette.ink.opacity(0.45))
                }
                .accessibilityLabel(L.string("Remove time", table: "SettingsDetail"))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }

    private func binding(for slot: ReadingReminderTimes.Slot) -> Binding<Date> {
        Binding(
            get: {
                Calendar.current.date(bySettingHour: slot.minutes / 60, minute: slot.minutes % 60, second: 0, of: Date()) ?? Date()
            },
            set: { date in
                let c = Calendar.current.dateComponents([.hour, .minute], from: date)
                if !times.replace(slot.id, with: (c.hour ?? 0) * 60 + (c.minute ?? 0)) { refusals += 1 }
                save()
            }
        )
    }

    private var permissionCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L.string("Notifications are off for Missale, so these times won't ring.", table: "SettingsDetail"))
                .font(MissaleFont.body(15))
                .foregroundStyle(Palette.ink)
            Button {
                if status == .notDetermined {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
                        ReadingReminderScheduler.refresh()
                        Task { await loadStatus() }
                    }
                } else if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text(status == .notDetermined
                     ? L.string("Allow notifications", table: "SettingsDetail")
                     : L.string("Open Settings", table: "SettingsDetail"))
                    .font(MissaleFont.body(16, weight: .semibold))
                    .foregroundStyle(Palette.wine)
            }
            .accessibilityIdentifier("notificationPermissionButton")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Palette.wine.opacity(0.1), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Palette.wine.opacity(0.24), lineWidth: 1))
    }

    private func card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(spacing: 0, content: content)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .background(Color.white.opacity(0.22), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Color.white.opacity(0.6), lineWidth: 1))
    }

    private func save() {
        ReadingReminderScheduler.times = times.minutes
        ReadingReminderScheduler.refresh()
    }

    private func loadStatus() async {
        let s = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        status = (s == .provisional || s == .ephemeral) ? .authorized : s
    }
}
