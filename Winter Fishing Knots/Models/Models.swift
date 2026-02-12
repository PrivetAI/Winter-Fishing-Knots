import Foundation

// MARK: - Knot Models
struct FishingKnot: Identifiable, Codable {
    let id: String
    let name: String
    let difficulty: Int // 1-5
    let strengthPercent: Int // line strength retention %
    let bestUse: String
    let steps: [String]
    let category: KnotCategory
}

enum KnotCategory: String, Codable, CaseIterable {
    case terminal = "Terminal"
    case lineToLine = "Line-to-Line"
    case loop = "Loop"
}

// MARK: - Rig Component Models
enum ComponentType: String, Codable, CaseIterable {
    case mainLine = "Main Line"
    case leader = "Leader"
    case hook = "Hook"
    case jig = "Jig"
    case sinker = "Sinker"
    case swivel = "Swivel"
    case float = "Float"
    case stopper = "Stopper"
    case spreader = "Spreader"
}

struct RigComponent: Identifiable, Codable {
    var id: String
    var type: ComponentType
    var label: String
    var detail: String
    var positionIndex: Int
}

// MARK: - Rig Template
struct RigTemplate: Identifiable, Codable {
    let id: String
    let name: String
    let targetSpecies: [String]
    let description: String
    let components: [RigComponent]
    let recommendedKnots: [String]
    let mainLineSpec: String
    let leaderSpec: String
}

// MARK: - Custom Rig (user-created)
struct CustomRig: Identifiable, Codable {
    var id: String
    var name: String
    var components: [RigComponent]
    var notes: String
    var rating: Int // 0-5
    var catchCount: Int
    var dateCreated: Date
    var lastUsed: Date?
}

// MARK: - Species for Line Calculator
struct FishSpecies: Identifiable, Codable {
    let id: String
    let name: String
    let avgWeightLbs: Double
    let maxWeightLbs: Double
    let recommendedLineLb: Double
    let recommendedLeaderLengthIn: Double
    let habitat: String
}

// MARK: - Tab Enum
enum AppTab: String, CaseIterable {
    case rigBuilder = "Rig Builder"
    case knots = "Knots"
    case library = "Library"
    case myRigs = "My Rigs"
    case calculator = "Calculator"
}

// MARK: - Static Data
struct KnotData {
    static let allKnots: [FishingKnot] = [
        FishingKnot(id: "palomar", name: "Palomar Knot", difficulty: 1, strengthPercent: 95,
                     bestUse: "Attaching hooks, lures, and swivels. Great all-purpose knot.",
                     steps: ["Double 6 inches of line and pass through the hook eye.",
                             "Tie an overhand knot with the doubled line, leaving the hook hanging.",
                             "Pass the loop over the hook completely.",
                             "Pull both ends to tighten. Trim excess."],
                     category: .terminal),
        FishingKnot(id: "improved_clinch", name: "Improved Clinch", difficulty: 1, strengthPercent: 89,
                     bestUse: "Quick connection for hooks and small lures. Best for mono under 20lb.",
                     steps: ["Thread line through hook eye, pull 6 inches through.",
                             "Wrap tag end around standing line 5-7 times.",
                             "Pass tag end through the small loop near the eye.",
                             "Pass tag end through the big loop you just made.",
                             "Moisten and pull tight. Trim."],
                     category: .terminal),
        FishingKnot(id: "uni", name: "Uni Knot", difficulty: 2, strengthPercent: 90,
                     bestUse: "Versatile terminal knot. Works with braid and mono.",
                     steps: ["Thread line through eye, make a loop alongside standing line.",
                             "Wrap tag end through the loop and around both lines 5-6 times.",
                             "Moisten and pull tag end to snug coils.",
                             "Slide knot to desired position. Pull main line to lock. Trim."],
                     category: .terminal),
        FishingKnot(id: "trilene", name: "Trilene Knot", difficulty: 2, strengthPercent: 93,
                     bestUse: "Extra strong terminal knot. Excellent for ice fishing jigs.",
                     steps: ["Thread line through hook eye twice to form a small double loop.",
                             "Wrap tag end around standing line 5 times.",
                             "Pass tag end through the double loop at the eye.",
                             "Moisten and pull slowly to tighten. Trim."],
                     category: .terminal),
        FishingKnot(id: "snell", name: "Snell Knot", difficulty: 3, strengthPercent: 97,
                     bestUse: "Strongest hook connection. Aligns hook for better hooksets.",
                     steps: ["Thread line through hook eye toward the point.",
                             "Form a small loop below the eye.",
                             "Wrap the tag end around the shank and line 7 times toward the bend.",
                             "Hold wraps, pull standing line to tighten against the eye. Trim."],
                     category: .terminal),
        FishingKnot(id: "blood", name: "Blood Knot", difficulty: 3, strengthPercent: 83,
                     bestUse: "Joining two similar-diameter lines. Classic fly-fishing knot.",
                     steps: ["Overlap the two line ends by 6 inches.",
                             "Wrap line A around line B 5 times.",
                             "Bring tag end A back between the two lines.",
                             "Wrap line B around line A 5 times in opposite direction.",
                             "Pass tag end B through the same gap, opposite direction of A.",
                             "Moisten and pull both standing lines to tighten. Trim both tags."],
                     category: .lineToLine),
        FishingKnot(id: "double_uni", name: "Double Uni Knot", difficulty: 2, strengthPercent: 85,
                     bestUse: "Joining braid to fluorocarbon leader. Reliable and easy.",
                     steps: ["Overlap both line ends by 8 inches.",
                             "With line A, form a uni knot (4 wraps) around line B.",
                             "With line B, form a uni knot (4 wraps) around line A.",
                             "Moisten and pull standing lines to slide knots together. Trim."],
                     category: .lineToLine),
        FishingKnot(id: "surgeons", name: "Surgeon's Knot", difficulty: 1, strengthPercent: 80,
                     bestUse: "Quick line-to-line join. Easy to tie with cold hands.",
                     steps: ["Lay both lines alongside each other, overlapping 6 inches.",
                             "Tie a simple overhand knot with both lines together.",
                             "Pass both lines through the loop a second time (double overhand).",
                             "Moisten and pull all four ends to tighten. Trim."],
                     category: .lineToLine),
        FishingKnot(id: "alberto", name: "Alberto Knot", difficulty: 4, strengthPercent: 88,
                     bestUse: "Braid to heavy leader. Very slim profile for casting.",
                     steps: ["Double the leader to form a loop.",
                             "Pass the braid through the loop.",
                             "Wrap braid around the doubled leader 7 times going away from the loop.",
                             "Wrap braid back over itself 7 times returning toward the loop.",
                             "Pass braid tag through the leader loop (same side it entered).",
                             "Moisten and slowly pull tight. Trim."],
                     category: .lineToLine),
        FishingKnot(id: "fg", name: "FG Knot", difficulty: 5, strengthPercent: 98,
                     bestUse: "Strongest braid-to-leader. Ultra slim, passes through guides.",
                     steps: ["Tension the braid in your teeth or on a cleat.",
                             "Lay the leader across the braid at 45 degrees.",
                             "Alternately wrap braid over and under the leader 15-20 times.",
                             "Half hitch the braid around the leader 3 times.",
                             "Trim the leader tag.",
                             "Half hitch around the braid only 3 more times. Trim braid tag."],
                     category: .lineToLine),
        FishingKnot(id: "dropper_loop", name: "Dropper Loop", difficulty: 3, strengthPercent: 85,
                     bestUse: "Creating a loop mid-line for droppers and extra hooks.",
                     steps: ["Form a loop in the standing line where you want the dropper.",
                             "Twist the loop around the standing line 5 times.",
                             "Pull the center of the original loop through the middle of the twists.",
                             "Moisten and pull both standing ends to lock. Adjust loop size."],
                     category: .loop),
        FishingKnot(id: "loop_knot", name: "Non-Slip Loop", difficulty: 2, strengthPercent: 87,
                     bestUse: "Gives lures free movement. Great for jigs in cold water.",
                     steps: ["Tie an overhand knot 5 inches from the tag end (do not tighten).",
                             "Pass the tag end through the hook eye.",
                             "Pass the tag end back through the overhand knot (same side it exited).",
                             "Wrap the tag end around the standing line 3-5 times.",
                             "Pass tag end back through the overhand knot.",
                             "Moisten and pull standing line to tighten. Trim."],
                     category: .loop),
    ]
}

struct RigData {
    static let allTemplates: [RigTemplate] = [
        RigTemplate(id: "drop_shot", name: "Drop Shot Rig", targetSpecies: ["Walleye", "Perch"],
                     description: "Suspends bait above the bottom. Ideal for finicky fish in clear water.",
                     components: [
                        RigComponent(id: "ds1", type: .mainLine, label: "Main Line", detail: "6-8lb Braid", positionIndex: 0),
                        RigComponent(id: "ds2", type: .leader, label: "Fluoro Leader", detail: "4-6lb x 24in", positionIndex: 1),
                        RigComponent(id: "ds3", type: .hook, label: "Drop Shot Hook", detail: "#4-#2 Octopus", positionIndex: 2),
                        RigComponent(id: "ds4", type: .sinker, label: "Drop Shot Weight", detail: "1/8-3/8oz Cylinder", positionIndex: 3),
                     ],
                     recommendedKnots: ["palomar", "double_uni"],
                     mainLineSpec: "6-8lb Braided", leaderSpec: "4-6lb Fluorocarbon, 18-30in"),
        RigTemplate(id: "tip_up", name: "Tip-Up Rig", targetSpecies: ["Pike", "Walleye", "Trout"],
                     description: "Classic ice fishing setup. Line deploys when fish takes bait.",
                     components: [
                        RigComponent(id: "tu1", type: .mainLine, label: "Dacron Line", detail: "30-40lb Braided Dacron", positionIndex: 0),
                        RigComponent(id: "tu2", type: .swivel, label: "Barrel Swivel", detail: "#7 Brass", positionIndex: 1),
                        RigComponent(id: "tu3", type: .leader, label: "Mono Leader", detail: "8-12lb x 36in", positionIndex: 2),
                        RigComponent(id: "tu4", type: .hook, label: "Treble Hook", detail: "#6-#2 Treble", positionIndex: 3),
                     ],
                     recommendedKnots: ["improved_clinch", "uni"],
                     mainLineSpec: "30-40lb Braided Dacron", leaderSpec: "8-12lb Monofilament, 24-36in"),
        RigTemplate(id: "jigging", name: "Jigging Rig", targetSpecies: ["Walleye", "Perch", "Crappie"],
                     description: "Direct connection for aggressive jigging through the ice.",
                     components: [
                        RigComponent(id: "jg1", type: .mainLine, label: "Main Line", detail: "4-6lb Braid", positionIndex: 0),
                        RigComponent(id: "jg2", type: .leader, label: "Fluoro Leader", detail: "3-5lb x 18in", positionIndex: 1),
                        RigComponent(id: "jg3", type: .jig, label: "Ice Jig", detail: "1/16-1/4oz Tungsten", positionIndex: 2),
                     ],
                     recommendedKnots: ["trilene", "loop_knot"],
                     mainLineSpec: "4-6lb Braided", leaderSpec: "3-5lb Fluorocarbon, 12-24in"),
        RigTemplate(id: "dead_stick", name: "Dead Stick Rig", targetSpecies: ["Crappie", "Bluegill", "Perch"],
                     description: "Stationary rod with subtle presentation. Let the fish come to you.",
                     components: [
                        RigComponent(id: "dst1", type: .mainLine, label: "Main Line", detail: "2-4lb Mono", positionIndex: 0),
                        RigComponent(id: "dst2", type: .float, label: "Spring Bobber", detail: "Sensitive Wire", positionIndex: 1),
                        RigComponent(id: "dst3", type: .sinker, label: "Split Shot", detail: "BB size", positionIndex: 2),
                        RigComponent(id: "dst4", type: .hook, label: "Ice Hook", detail: "#8-#12 Aberdeen", positionIndex: 3),
                     ],
                     recommendedKnots: ["palomar", "trilene"],
                     mainLineSpec: "2-4lb Monofilament", leaderSpec: "N/A - direct tie"),
        RigTemplate(id: "panfish", name: "Panfish Rig", targetSpecies: ["Bluegill", "Crappie", "Perch"],
                     description: "Ultra-light finesse setup for panfish through the ice.",
                     components: [
                        RigComponent(id: "pf1", type: .mainLine, label: "Main Line", detail: "1-3lb Mono", positionIndex: 0),
                        RigComponent(id: "pf2", type: .float, label: "Tiny Float", detail: "1/64oz Balsa", positionIndex: 1),
                        RigComponent(id: "pf3", type: .jig, label: "Micro Jig", detail: "1/64-1/32oz Tungsten", positionIndex: 2),
                     ],
                     recommendedKnots: ["palomar", "improved_clinch"],
                     mainLineSpec: "1-3lb Monofilament", leaderSpec: "N/A - direct tie"),
        RigTemplate(id: "pike_tipup", name: "Pike Tip-Up", targetSpecies: ["Northern Pike", "Muskie"],
                     description: "Heavy-duty tip-up rig with wire leader for toothy predators.",
                     components: [
                        RigComponent(id: "pt1", type: .mainLine, label: "Dacron Line", detail: "50lb Braided Dacron", positionIndex: 0),
                        RigComponent(id: "pt2", type: .swivel, label: "Heavy Swivel", detail: "#3 Ball Bearing", positionIndex: 1),
                        RigComponent(id: "pt3", type: .leader, label: "Wire Leader", detail: "30lb x 12in Steel", positionIndex: 2),
                        RigComponent(id: "pt4", type: .hook, label: "Quick-Strike", detail: "#4-#2 Treble x2", positionIndex: 3),
                     ],
                     recommendedKnots: ["improved_clinch", "uni"],
                     mainLineSpec: "50lb Braided Dacron", leaderSpec: "30lb Wire, 10-14in"),
        RigTemplate(id: "walleye_jig", name: "Walleye Jigging", targetSpecies: ["Walleye"],
                     description: "Precision jigging rig tuned for walleye behavior under ice.",
                     components: [
                        RigComponent(id: "wj1", type: .mainLine, label: "Main Line", detail: "6lb Superline", positionIndex: 0),
                        RigComponent(id: "wj2", type: .leader, label: "Fluoro Leader", detail: "5lb x 30in", positionIndex: 1),
                        RigComponent(id: "wj3", type: .jig, label: "Jigging Rap", detail: "1/4oz", positionIndex: 2),
                     ],
                     recommendedKnots: ["loop_knot", "double_uni"],
                     mainLineSpec: "6lb Superline Braid", leaderSpec: "4-6lb Fluorocarbon, 24-36in"),
        RigTemplate(id: "perch_spreader", name: "Perch Spreader", targetSpecies: ["Yellow Perch"],
                     description: "Dual-hook spreader for targeting perch schools at multiple depths.",
                     components: [
                        RigComponent(id: "ps1", type: .mainLine, label: "Main Line", detail: "4-6lb Mono", positionIndex: 0),
                        RigComponent(id: "ps2", type: .spreader, label: "Spreader Arm", detail: "Wire Spreader", positionIndex: 1),
                        RigComponent(id: "ps3", type: .hook, label: "Upper Hook", detail: "#6 Aberdeen", positionIndex: 2),
                        RigComponent(id: "ps4", type: .hook, label: "Lower Hook", detail: "#6 Aberdeen", positionIndex: 3),
                        RigComponent(id: "ps5", type: .sinker, label: "Bottom Weight", detail: "1/4oz Bell", positionIndex: 4),
                     ],
                     recommendedKnots: ["improved_clinch", "dropper_loop"],
                     mainLineSpec: "4-6lb Monofilament", leaderSpec: "Direct tie to spreader"),
    ]
}

struct SpeciesData {
    static let allSpecies: [FishSpecies] = [
        FishSpecies(id: "walleye", name: "Walleye", avgWeightLbs: 3.0, maxWeightLbs: 15.0,
                     recommendedLineLb: 6, recommendedLeaderLengthIn: 24, habitat: "Deep structure, gravel"),
        FishSpecies(id: "perch", name: "Yellow Perch", avgWeightLbs: 0.5, maxWeightLbs: 2.5,
                     recommendedLineLb: 4, recommendedLeaderLengthIn: 12, habitat: "Weed edges, flats"),
        FishSpecies(id: "crappie", name: "Crappie", avgWeightLbs: 0.75, maxWeightLbs: 3.0,
                     recommendedLineLb: 3, recommendedLeaderLengthIn: 12, habitat: "Brush piles, basins"),
        FishSpecies(id: "bluegill", name: "Bluegill", avgWeightLbs: 0.3, maxWeightLbs: 1.5,
                     recommendedLineLb: 2, recommendedLeaderLengthIn: 8, habitat: "Shallow weeds"),
        FishSpecies(id: "pike", name: "Northern Pike", avgWeightLbs: 8.0, maxWeightLbs: 40.0,
                     recommendedLineLb: 15, recommendedLeaderLengthIn: 12, habitat: "Weed beds, points"),
        FishSpecies(id: "lake_trout", name: "Lake Trout", avgWeightLbs: 5.0, maxWeightLbs: 50.0,
                     recommendedLineLb: 10, recommendedLeaderLengthIn: 30, habitat: "Deep basins, shoals"),
        FishSpecies(id: "rainbow", name: "Rainbow Trout", avgWeightLbs: 2.0, maxWeightLbs: 12.0,
                     recommendedLineLb: 4, recommendedLeaderLengthIn: 24, habitat: "Stocked lakes, inlets"),
        FishSpecies(id: "whitefish", name: "Whitefish", avgWeightLbs: 2.5, maxWeightLbs: 10.0,
                     recommendedLineLb: 4, recommendedLeaderLengthIn: 18, habitat: "Deep flats, mid-lake"),
    ]
}
