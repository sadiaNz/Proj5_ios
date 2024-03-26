//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let rainbow: [UIColor] = [.red, .yellow, .green, .orange, .blue, .purple, .magenta]
    var postData = [postViewData()];
    var allImages = [UIImage()];
    @IBOutlet var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCellTableViewCell", for: indexPath) as! customTableCellTableViewCell
        Nuke.loadImage(with: postData[indexPath.item].url, into: cell.imageView1!)
        cell.textArea.text = postData[indexPath.item].detailText
        return cell
        
    }
    
  
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        let nibb = UINib(nibName: "customTableCellTableViewCell", bundle: nil)
        tableView.register(nibb, forCellReuseIdentifier: "customTableCellTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 10.0, *)
        {
            tableView.refreshControl = refreshControl
        } 
        else
        {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshPostData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        fetchPosts()
        
    }
    @objc private func refreshPostData(_ sender: Any)
    {
        fetchPosts()
    }
    func fetchPosts() 
    {
        print("fetchPosts")
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts

                    posts.forEach
                    {
                        post in self!.postData.append(postViewData(url: post.photos[0].originalSize.url, detailText: post.summary) )
                    }
                
                    self!.tableView.reloadData()
                    self!.refreshControl.endRefreshing()
                   // self.activityIndicatorView.stopAnimating()
                    print("✅ We got \(posts.count) post")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }

}
