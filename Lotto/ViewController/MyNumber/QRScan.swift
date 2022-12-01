//
//  QRScan.swift
//  Lotto
//
//  Created by Qtec on 2022/12/01.
//

import Foundation

//TODO: 추후 자동, 반자동, 수동 구분이 가능하다면 수정할 것
struct QRScan {
    
    private(set) var round: Int
    private(set) var nums: [[Int]]
    
    init?(from urlString: String) {
        
        //동행복권 사이트가 아닐 경우
        guard urlString.contains("dhlottery.co.kr") else {
            return nil
        }
        
        //QR스캔이 아닌 경우
        var components = urlString.components(separatedBy: "q")
        guard !components.isEmpty else {
            return nil
        }
        
        //회차 찾기
        let arr = components[0].components(separatedBy: "v=")
        guard
            let value = arr.last,
            let round = Int(value)
        else {
            return nil
        }
        
        components.removeFirst()
        self.round = round
        
        //번호 찾기
        var nums = [[Int]]()
        components.forEach { component in
            var c = component
            
            var arr = [Int]()
            (0...5).forEach { _ in
                let index = c.index(c.startIndex, offsetBy: 2)
                if let num = Int(c[c.startIndex..<index]) {
                    c = String(c[index..<c.endIndex])
                    arr.append(num)
                }
            }
            
            guard arr.count == 6 else {return}
            nums.append(arr)
        }
        
        guard !nums.isEmpty else {
            return nil
        }
        
        self.nums = nums
    }
}
