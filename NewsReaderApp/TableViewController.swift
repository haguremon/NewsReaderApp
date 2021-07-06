//
//  TableViewController.swift
//  NewsReaderApp
//
//  Created by IwasakIYuta on 2021/07/06.
//

import UIKit

class TableViewController: UITableViewController , XMLParserDelegate {
    var parser: XMLParser!//RSSデータを解析するXMLParser型のプロパティ
    var items = [Items]()//Items型の空の複数の記事を保存する配列
    var item: Items? //空の可能性もあるのでオプショナル型
    var currentString = "" //解析で抽出した一時的に確保するプロパティ
    
    override func viewDidLoad() {
        super.viewDidAppear(true)
        startDownload()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
//セクションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //dequeueReusableCellで効率よく（メモリ等）使うことができる

        // Configure the cell...
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    //XMLコードをダウンロードする
    func startDownload(){
        self.items = [] //記事がここに入る
        if let url = URL(string: "https://wired.jp/rssfeeder/"){ //WebサイトのURLでこれがある時に
            if let parser = XMLParser(contentsOf: url)  { //インスタンス化//解析するURLを取るconvenience init?(contentsOf url: URL)失敗可能なコンビニエンスイニシャライザやなだからアンラップしてる
            self.parser = parser
            parser.delegate = self //delegateパターンでTableViewControllerに通知を受け取るようにしないとcellに表示もされない
            self.parser.parse()
            }
        }
        
        
        
    }
    //要素名の開始タグを見つけること毎に呼ばれるメソッドXMLParserDelegateで宣言されてるメソッド
   //ニュース記事の要素見つけるここの場合はitemを見つけて
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentString = ""
        if elementName == "item" {
            self.item = Items()
        }
    }
    //内容を取り出す
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString += string
    }
    //</>Htmlナッツｗの終了ダグが見つかると呼ばれるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "title": self.item?.title = currentString
        case "link": self.item?.link = currentString
        case "item": self.items.append(self.item!)
        default:
            break
        }
    }
    //解析したデータを表示する処理
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()//reloadDataを使うとことによって
    }
    //遷移させる処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
        let item = items[indexPath.row] //indexPathForSelectedRowで選択したセルを認知することができる
            let vc = segue.destination as! DatailViewController
//destinationメソッドは遷移先のViewControllerを指定することができる
            vc.title = item.title
            vc.link = item.link
            
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
