window.queries = new function() {
  this.social_network = function() {
    var source = document.getElementById('query').value;
    console.log(source);
    if (source == "") {
      alert("Need to introduce a genre to do a valid query");
      return;
    }
    console.log("social_network "+source);
     $.getJSON('network/'+source, function(data) {
        var i = 0;
        graph.clear();
        while(i < data.length) {
          var node = data[i]
          var f = graph.addNode(node.title, { title: node.title, x: Math.random(), y: Math.random(), color: '#b8f27d', type: 'movie'});
          var j = 0;
          while ( j < data[i].genres.length) {
            var genre  = data[i].genres[j];
            var t = graph.addNode(genre, { genre: genre, x: Math.random(), y: Math.random(), color: '#ccc', type: 'genre' });
            graph.addEdge(i+"#"+genre, node.title, genre);
            j += 1;
          }
          i += 1
        }
        /* BIND EVENTS */
        var me = graph.sigma;
        me.bind('overnodes',function(event){
            var nodes = event.content;
            var neighbors = {};
            me.iterEdges(function(e){
              if(nodes.indexOf(e.source)>=0 || nodes.indexOf(e.target)>=0){
                neighbors[e.source] = 1;
                neighbors[e.target] = 1;
            }})
            .iterNodes(function(n){
              if(!neighbors[n.id]){
                n.hidden = 1;
                n.active = false;
              }else{
                n.hidden = 0;
                n.active=true;
              }
              }).draw(2,2,2);
            }).bind('outnodes',function(){
             me.iterEdges(function(e){
               e.hidden = 0;
            }).iterNodes(function(n){
               n.hidden = 0;
               n.active = false;
            }).draw(2,2,2);
        });
        /* END EVENTS */
        /* START LAYOUT */
        var i = 0;
        var g = 0;
        var G = 0;
        me.iterNodes(function(n) {
          if (n.attr.type == 'genre') {
            G++;
          }
        });
        var L = me.getNodesCount()-G;
        me.iterNodes(function(n) {
          if (n.attr.type == 'movie') {
            n.x = Math.cos(Math.PI*(i)/L)*50;
            n.y = Math.sin(Math.PI*(i)/L)*50;
            i += 2;
          } else if (n.attr.type == 'genre') {
            n.x = Math.cos(Math.PI*(g)/G)*10;
            n.y = Math.sin(Math.PI*(g)/G)*10;
            g += 2;
          } else {
            n.x = 0;
            n.y = 0;
          }
        });
        me.draw(2,2,2);
        /* END LAYOUT*/
        console.log("graph added");
      });
  }
};
