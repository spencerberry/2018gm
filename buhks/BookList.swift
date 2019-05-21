import UIKit

class BookList: UITableViewController, UISearchResultsUpdating {

    private lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()
    
    var books: [BookViewModel] = []
    
    let networkRequest = NetworkRequest()
    let scheduler = Scheduler(seconds: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertSearchController()
        title = "find a buhk"
    }
    
    private func search(term: String){
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else{
            return
        }
        
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(encodedTerm)"
        let url = URL(string: urlString)!
        
        networkRequest.get(url: url){ (books, error) in
            
            if let error = error{
                DispatchQueue.main.async{
                    self.showError(error)
                }
                return
            }
            
            self.books = books ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func showError(_ error: Error){
        let description = error.localizedDescription
        let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "sorry", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true)
    }
    private func insertSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find a book..."
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)

        let book = books[indexPath.row]
        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
       // cell.imageView?.image = UIImage(named: "book-icon")
        
        if let url = URL(string: book.thumbnail){
            cell.imageView?.kf.setImage(with: url, placeholder: UIImage(named: "book-icon"))
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let book = sender as? BookViewModel,
            let bookController = segue.destination as? BookViewController
        else{
            return
        }
        
        bookController.book = book
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.row]
        
        performSegue(withIdentifier:"ToBookSegue", sender: selectedBook)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerm = searchController.searchBar.text, searchTerm.isEmpty == false{
            scheduler.debounce { [weak self] in
                self?.search(term: searchTerm)
            }
        }
    }
}
