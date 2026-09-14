import SwiftUI

/// t5 screen 10 (fIs10) — tap-to-expand FAQ accordion.
struct FAQView: View {
    @State private var openID: String?

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Perguntas frequentes")
                            .font(MissaleFont.display(29, weight: .semibold))
                        Text("Toque para abrir.")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    ForEach(MockSettings.faq) { item in
                        let isOpen = openID == item.id
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                openID = isOpen ? nil : item.id
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text(item.question)
                                        .font(MissaleFont.body(17, weight: .medium))
                                        .foregroundStyle(Palette.ink)
                                        .multilineTextAlignment(.leading)
                                    Spacer(minLength: 8)
                                    Text(isOpen ? "\u{2212}" : "+")
                                        .font(MissaleFont.body(18))
                                        .foregroundStyle(Palette.wine)
                                }
                                if isOpen {
                                    Text(item.answer)
                                        .font(MissaleFont.body(16))
                                        .foregroundStyle(Palette.ink.opacity(0.82))
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .background(Color.white.opacity(0.22), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Color.white.opacity(0.6), lineWidth: 1))
                    }

                    DashedUtilityCard {
                        Text("Não achou? Escreva para \(MockSettings.supportEmail) — respondemos em até dois dias úteis.")
                            .font(MissaleFont.body(16))
                            .foregroundStyle(Palette.ink.opacity(0.8))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
