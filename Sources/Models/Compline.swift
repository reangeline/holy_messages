import Foundation

/// The texts read on the Compline screen. They are content, not chrome: each
/// language quotes a published edition of its own, never a translation of
/// another language's — the same rule the Examen's psalms follow.
///
/// The two versicles are Scripture (Ps 84,5 and Ps 69,2 in the Vulgate
/// numbering the three editions print), so they come from the same
/// public-domain bibles. The doxology is a fixed liturgical formula and comes
/// from the Compendium of the Catechism, which is also where the app's prayer
/// catalog takes it from — see `MockDevotionalPrayers`.
struct ComplineText {
    /// "Convert us, O God our saviour" — the versicle that opens Compline.
    let opening: String
    /// "O God, come to my assistance" — the invitatory of every hour.
    let invitatory: String
    /// The trinitarian doxology that closes the invitatory.
    let gloryBe: String

    /// Label for the night psalm, in the Hebrew numbering the app displays.
    let psalmLabel: String
    let psalmText: String

    /// Editions quoted, with the printed reference where it differs from the
    /// displayed one. Shown on the screen so the reader knows what they read.
    let source: String

    /// What this screen actually holds. It used to claim "full text, offline",
    /// which the three texts here do not deliver.
    let note: String
}
