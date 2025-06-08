//
//  SummarizationService.swift
//  Summary_Application
//
//  Created by 鈴木廉太郎 on 2025/06/08.
//

import Reductio

final class SummarizationService {
    static func summarize(_ text: String, sentences: Int = 3) -> String {
        var summary = ""
        Reductio.summarize(text: text, numberOfSentences: sentences) { result in
            summary = result.joined(separator: " ")
        }
        return summary
    }
}
