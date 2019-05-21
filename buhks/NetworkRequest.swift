
import Foundation

struct NetworkRequest{
    
    func get(url: URL, callback: @escaping ([BookViewModel]?, Error?) -> Void){
       
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
            guard let data = data else{
                return
            }
        
            do{
                let googleBooksRoot = try
                    JSONDecoder().decode(GoogleBooksRoot.self, from: data)
                
                let books = self.createBooks(from: googleBooksRoot)
                
                callback(books, nil)
                
            } catch{
                callback(nil, error)
            }
        }
        dataTask.resume()
    }
    
    func createBooks(from googleBookRoot: GoogleBooksRoot) -> [BookViewModel] {
        
        return googleBookRoot.items.map { (googleBook) -> BookViewModel
            in
            return BookViewModel(
                title: googleBook.volumeInfo.title,
                subtitle: googleBook.volumeInfo.subtitle ?? "No subtitle",
                author: googleBook.volumeInfo.authors?.first ?? "No author",
                extendedDescription: googleBook.volumeInfo.description ?? "Description Missing",
                thumbnail: googleBook.volumeInfo.imageLinks?.smallThumbnail ?? ""
            )
        }
    }
}
