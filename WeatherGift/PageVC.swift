//
//  PageVC.swift
//  WeatherGift
//
//  Created by CSOM on 3/19/17.
//  Copyright © 2017 CSOM. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    
    var currentPage = 0
    
    var locationsArray = ["Local City Weather", "Chestnut Hill, MA", "Sydney, Australia", "Uglich, Russia"]
    
    var pageControl: UIPageControl!
    
    var listButton: UIButton!
    
    
    let barButtonWidth: CGFloat = 44
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
        configurePageConrol()
        configureListButton()
        

    }
    
    //Mark: - UI Configuration Methods
    func configurePageConrol() {
        let pageControlHeight: CGFloat = barButtonWidth
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: view.frame.height - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        
        view.addSubview(pageControl)
    }
    
    func configureListButton(){
        let barButtonHeight = barButtonWidth
        
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: view.frame.height - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setBackgroundImage(UIImage(named: "listButton"), for: .normal)
        listButton.setBackgroundImage(UIImage(named: "listButtonHighlighted"), for: .highlighted)
        
        listButton.addTarget(self, action: #selector(segueToLocationsVC), for: .touchUpInside)
        
        view.addSubview(listButton)
        
        
    }
    
    func segueToLocationsVC() {
        print ("fuck you")
    }
    
    //Mark: - Create View Controller for UIPageViewController
    func createDetailVC(forPage page: Int) -> DetailVC {
        
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC")
            as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        
        
        return detailVC
        
        
    }


}


extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count - 1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage - 1)
            }
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVC
        {
            pageControl.currentPage = currentViewController.currentPage
            
        }
        
    }
}
