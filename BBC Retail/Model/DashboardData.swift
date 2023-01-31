//
//  DashboardData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 24, 2022
//
import Foundation

struct DashboardData: Codable {

	let reportData: ReportData?
	let settlementReport: SettlementReport?
	let salesReportData: [SalesReportData]?

	private enum CodingKeys: String, CodingKey {
		case reportData = "reportData"
		case settlementReport = "settlementReport"
		case salesReportData = "salesReportData"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		reportData = try values.decodeIfPresent(ReportData.self, forKey: .reportData)
		settlementReport = try values.decodeIfPresent(SettlementReport.self, forKey: .settlementReport)
		salesReportData = try values.decodeIfPresent([SalesReportData].self, forKey: .salesReportData)
	}

    

}
