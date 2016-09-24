var graph = new function() {
    this.init = function () {
        this.sigma = sigma.init(document.getElementById('silvia-graph')).drawingProperties({
          defaultLabelColor: '#ccc',
          font: 'Arial',
          defaultEdgeType: 'line',
          labelThreshold: 5,
        }).graphProperties({
          minNodeSize: 5,
          maxNodeSize: 5,
          minEdgeSize: 5,
          maxEdgeSize: 5
        });
        console.log("sigma init");
    },
    this.addNode=function(id, config) {
      if (this.existNode(id)) {
        return this.sigma.getNodes(id);
      }
      return this.sigma.addNode(id, config);
    },
    this.getNode=function(id) {
      return this.sigma.getNodes(id);
    },
    this.existNode=function(id) {
      try {
        this.sigma.getNodes(id);
        return true;
      } catch(err) {
        return false;
      }
    },
    this.addEdge=function(id, from, to) {
      return this.sigma.addEdge(id, from, to)
    },
    this.getEdge=function(id) {
      return this.sigma.getEdges(id);
    },
    this.existEdge=function(id) {
      try {
        this.sigma.getEdges(id);
        return true;
      } catch(err) {
        return false;
      }
    },
    this.dropNode=function(id) {
      this.sigma.dropNode(id);
    },
    this.dropEdge=function(id) {
      this.sigma.dropEdge(id);
    },
    this.clear=function() {
      this.sigma.emptyGraph();
      this.sigma.refresh();
     
    },
    this.draw=function() {
      this.sigma.draw();
    },
    this.circleLayout=function() {
    },
    this.zoom=function(level) {
      var screen = window.screen;
      this.sigma.zoomTo(screen.width/2,screen.height/2,level);
      this.sigma.refresh();
    }
}
