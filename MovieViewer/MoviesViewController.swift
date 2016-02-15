//  MoviesViewController.swift
//  MovieViewer
//
//  Created by  on 2/1/16.
//  Copyright © 2016 CodePath. All rights reserved.
//
//



import UIKit
import AFNetworking
import MBProgressHUD


let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //Show HUD before request is made
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        //Hide HUD if request goes back (required on UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                            
                    }
                }
        })
        task.resume()
        // Do any additional setup after loading the view.
        
        
        
        
        // Makes a network request to get updated data
        // Updates the tableView with the new data
        // Hides the RefreshControl
        func refreshControlAction(refreshControl: UIRefreshControl) {
            
            // ... Create the NSURLRequest (myRequest) ...
            
            let myRequest = NSURLRequest(
                URL: url!,
                cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            
            // Configure session so that completion handler is executed on main UI thread
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: nil,
                delegateQueue: NSOperationQueue.mainQueue()
                
            )
            
            let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
                completionHandler: { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                print("response: \(responseDictionary)")
                                
                                self.movies = responseDictionary["results"] as? [NSDictionary]
                                self.tableView.reloadData()
                                
                        }
                    }
            })
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
            
        };
        
        task.resume()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // No recreated resources
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterImageView.setImageWithURL(imageUrl!)
        
        
        }
        
        
        print("row \(indexPath.row)")
        return cell
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailsViewController = segue.destinationViewController as! DetailsViewController
        detailsViewController.movie = movie
        
        print("prepare for segue called")
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
                    }

}

