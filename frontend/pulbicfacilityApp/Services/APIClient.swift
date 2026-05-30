import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int, String)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidResponse:
            return "서버 응답이 올바르지 않습니다."
        case .serverError(let code, let message):
            return "서버 오류 \(code): \(message)"
        case .decodingError:
            return "데이터 변환에 실패했습니다."
        }
    }
}

final class APIClient {
    static let shared = APIClient()
    
    private init() {}
    
    // 시뮬레이터에서는 localhost 사용 가능
    // 실제 아이폰에서 테스트할 때는 Mac의 IP 주소로 변경
    // 예: http://192.168.0.10:8080
    let baseURL = "http://localhost:8080"
    
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    func request<T: Decodable>(
        path: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if !(200..<300).contains(httpResponse.statusCode) {
            let message = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            print("API Error:", httpResponse.statusCode, message)
            throw APIError.serverError(httpResponse.statusCode, message)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding Error:", error)
            print("Response Body:", String(data: data, encoding: .utf8) ?? "")
            throw APIError.decodingError
        }
    }
    
    func requestWithoutResponse(
        path: String,
        method: String = "POST",
        body: Data? = nil
    ) async throws {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if !(200..<300).contains(httpResponse.statusCode) {
            let message = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            print("API Error:", httpResponse.statusCode, message)
            throw APIError.serverError(httpResponse.statusCode, message)
        }
    }
}
