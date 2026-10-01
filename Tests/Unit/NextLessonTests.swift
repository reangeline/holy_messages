import XCTest
@testable import Missale

/// "Continue" on the end-of-part screen opens the next part of the same track.
final class NextLessonTests: XCTestCase {
    private func lesson(_ id: String, track: String, part: Int, of total: Int) -> FormationLesson {
        FormationLesson(id: id, trackID: track, partNumber: part, partsTotal: total, kicker: "k", title: "t\(part)",
                        bodyParagraphs: ["p"], quoteText: nil, quoteAttribution: nil, glossaryTerms: [])
    }

    private func track(_ id: String, parts: Int) -> FormationTrack {
        FormationTrack(id: id, title: id, meta: "", progress: 0, nextUp: "",
                       lessons: (1...parts).map { lesson("\(id)-\($0)", track: id, part: $0, of: parts) })
    }

    func testMiddleOfTrackGivesTheNextPart() {
        let tracks = [track("a", parts: 3), track("b", parts: 2)]
        XCTAssertEqual(tracks[0].lessons[0].next(in: tracks)?.id, "a-2")
        XCTAssertEqual(tracks[0].lessons[1].next(in: tracks)?.id, "a-3")
    }

    func testLastPartHasNoNext() {
        let tracks = [track("a", parts: 3), track("b", parts: 2)]
        XCTAssertNil(tracks[0].lessons[2].next(in: tracks))
        XCTAssertNil(tracks[1].lessons[1].next(in: tracks))
    }

    func testLessonOfUnknownTrackHasNoNext() {
        let tracks = [track("a", parts: 3)]
        XCTAssertNil(lesson("x-1", track: "x", part: 1, of: 2).next(in: tracks))
    }
}
