(function() {
    d3.json('/api/online', function(err, projects) {
        if (err) return;

        var W = window.innerWidth,
            H = window.innerHeight,
            R = Math.min(0.4*W/(projects.length+1), 50);

        projects.sort(function(a,b){ return a.localeCompare(b); });

        d3.select('body')
            .append('svg')
                .attr('width', W)
                .attr('height', H)
                .style('position','absolute')
                .style('top', 0)
                .style('left', 0)
                .style('font','1.4em "Rock Salt" cursive');

        d3.select('svg').selectAll('circle')
            .data(projects).enter().append('circle')
                .attr('r', R +'px')
                .attr('cx', function(d,i){ return (i + 1)*W/(projects.length+1); })
                .attr('cy', H/2)
                .attr('stroke-width', R/2)
                .attr('stroke', function(d,i){ return 'hsl('+ (i*360/(projects.length+1)) +',100%,40%)'; })
                .attr('fill', function(d,i){ return 'hsl('+ (i*360/(projects.length+1)) +',100%,80%)'; })
                .style('cursor','pointer')
                .on('click',
                    function(d) {
                        if (d == 'info') alert('Right HERE!');
                        else if (d == 'api') window.location.href = '/api';
                        else window.location.href = '/projects/'+ d;
                    })
                .on('mouseover',
                    function() {
                        d3.select(this)
                            .transition()
                                .duration(333)
                                .styleTween('stroke-opacity', function(d,i) { return d3.interpolate(1,0.3); });
                    })
                .on('mouseout',
                    function() {
                        d3.select(this)
                            .transition()
                                .delay(333)
                                .duration(777)
                                .styleTween('stroke-opacity', function(d,i) { return d3.interpolate(0.3,1); });
                    })
                .transition()
                    .duration(function(d,i){ return 777*(i + 1); })
                    .styleTween('opacity', function(d,i) { return d3.interpolate(0,1); });

        d3.select('svg').selectAll('circle')
            .append('title')
                .text(function(d){ return d == 'info' ? 'Right HERE!' : d == 'api' ? 'Go to API!' :'Go to project!'; });

        d3.select('svg').selectAll('text')
            .data(projects).enter().append('text')
                .attr('x', function(d,i){ return (i + 1)*W/(projects.length+1); })
                .attr('y', H/2 + 1.7*R)
                .attr('text-anchor','middle')
                .attr('fill', function(d,i){ return 'hsl('+ (i*360/(projects.length+1)) +',100%,30%)'; })
                .style('font-size','1em')
                .text(function(d){ return d; });
    });
})();
