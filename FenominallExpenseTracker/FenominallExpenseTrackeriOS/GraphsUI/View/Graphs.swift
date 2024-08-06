//
//  Graphs.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 03.06.2024.
//

import SwiftUI
import Charts
import FenominallExpenseTracker

struct Graphs: View {
    @StateObject var viewModel: ChartTransactionsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ChartView()
                        .frame(height: 200)
                        .padding(10)
                        .padding(.top, 10)
                        .background(.background, in: .rect(cornerRadius: 10))
                    
                    ForEach(viewModel.chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                                .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Graphs")
            .background(Color.gray.opacity(0.15))
            .onAppear {
                viewModel.createChartGroup()
            }
        }
    }
    
    @ViewBuilder
    private func ChartView() -> some View {
        Chart {
            ForEach(viewModel.chartGroups) { group in
                ForEach(group.types) { chart in
                    BarMark(
                        x: .value("Month", viewModel.format(date: group.date, format: "MMM yy")),
                        y: .value(chart.type.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.type.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.type.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text(viewModel.axisLabel(doubleValue))
                }
            }
        }
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
}

extension View {
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}
