import SwiftUI
import SwiftData
import Charts

struct ProgressView: View {
    let appState: AppState
    @Query(sort: \WorkoutSession.date) private var sessions: [WorkoutSession]

    private var completedDays: Int { sessions.count }
    private var bestMaxSet: Int { sessions.map(\.maxSetReps).max() ?? 0 }
    private var progressFraction: Double {
        min(Double((appState.currentWeek - 1) * 3 + appState.currentDay - 1) / 18.0, 1.0)
    }

    var body: some View {
        ZStack {
            DS.Colors.offWhite.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Progress")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(DS.Colors.black)
                        Text("Week \(appState.currentWeek) of 6")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(DS.Colors.mediumGray)
                    }
                    .padding(.horizontal, DS.Layout.horizontalMargin)
                    .padding(.top, 16)

                    // Chart
                    CardView {
                        if sessions.isEmpty {
                            Text("Complete your first workout to see progress.")
                                .font(.system(size: 15))
                                .foregroundStyle(DS.Colors.mediumGray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 160)
                        } else {
                            Chart(sessions) { session in
                                LineMark(
                                    x: .value("Day", session.date, unit: .day),
                                    y: .value("Max Reps", session.maxSetReps)
                                )
                                .foregroundStyle(DS.Colors.superRed)
                                .lineStyle(StrokeStyle(lineWidth: 2))

                                PointMark(
                                    x: .value("Day", session.date, unit: .day),
                                    y: .value("Max Reps", session.maxSetReps)
                                )
                                .foregroundStyle(DS.Colors.superRed)
                            }
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day, count: 3)) { _ in
                                    AxisValueLabel(format: .dateTime.day())
                                        .foregroundStyle(DS.Colors.lightGray)
                                    AxisGridLine().foregroundStyle(Color.clear)
                                }
                            }
                            .chartYAxis {
                                AxisMarks { _ in
                                    AxisValueLabel()
                                        .foregroundStyle(DS.Colors.lightGray)
                                    AxisGridLine().foregroundStyle(Color.clear)
                                }
                            }
                            .frame(height: 160)
                        }
                    }
                    .padding(.horizontal, DS.Layout.horizontalMargin)

                    // Stats row
                    CardView {
                        HStack(spacing: 0) {
                            StatCell(value: "\(completedDays)", label: "Days\nCompleted")
                            Divider().frame(height: 40)
                            StatCell(value: "\(bestMaxSet)", label: "Best\nMax Set")
                            Divider().frame(height: 40)
                            StatCell(value: "50", label: "Goal")
                        }
                    }
                    .padding(.horizontal, DS.Layout.horizontalMargin)

                    // Program timeline
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(DS.Colors.dividerGray)
                                        .frame(height: 6)

                                    Capsule()
                                        .fill(DS.Colors.superRed)
                                        .frame(width: geo.size.width * progressFraction, height: 6)

                                    Circle()
                                        .fill(DS.Colors.superRed)
                                        .frame(width: 14, height: 14)
                                        .overlay(Circle().fill(DS.Colors.white).frame(width: 6, height: 6))
                                        .offset(x: max(0, geo.size.width * progressFraction - 7))
                                }
                            }
                            .frame(height: 14)

                            HStack {
                                ForEach(1...6, id: \.self) { week in
                                    Text("W\(week)")
                                        .font(.system(size: 12))
                                        .foregroundStyle(DS.Colors.lightGray)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DS.Layout.horizontalMargin)
                    .padding(.bottom, DS.Layout.bottomNavHeight + 16)
                }
            }
        }
    }
}

struct StatCell: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(DS.Colors.black)
            Text(label)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(DS.Colors.mediumGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
